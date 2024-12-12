import os
from spleeter.separator import Separator
from flask import Flask, request, jsonify, send_from_directory, url_for
from werkzeug.utils import secure_filename

UPLOAD_FOLDER = 'upload'
OUTPUT_FOLDER = 'output'
MAX_CONTENT_LENGTH = 16 * 1000 * 1000  # 16MB
ALLOWED_EXTENSIONS = {'mp3', 'wav'}

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['OUTPUT_FOLDER'] = OUTPUT_FOLDER
app.config['MAX_CONTENT_LENGTH'] = MAX_CONTENT_LENGTH

# Tạo thư mục upload và output nếu chưa tồn tại
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(OUTPUT_FOLDER, exist_ok=True)

# Kiểm tra định dạng file hợp lệ
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        input_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        output_dir = os.path.join(app.config['OUTPUT_FOLDER'], filename.rsplit('.', 1)[0])
        
        # Lưu file vào thư mục UPLOAD_FOLDER
        file.save(input_path)
        
        # Tách nhạc bằng Spleeter
        separator = Separator('spleeter:2stems')
        separator.separate_to_file(input_path, output_dir)

        # Trả về URL đầy đủ tới các file đã tách
        return jsonify({
            'vocals': url_for('download_file', name=filename.rsplit('.', 1)[0], part='vocals.wav', _external=True),
            'accompaniment': url_for('download_file', name=filename.rsplit('.', 1)[0], part='accompaniment.wav', _external=True)
        })
    else:
        return jsonify({'error': 'Invalid file format. Only mp3 and wav are allowed.'}), 400

@app.route('/outputs/<name>/<part>', methods=['GET'])
def download_file(name, part):
    destination = os.path.join(app.config['OUTPUT_FOLDER'], name)
    return send_from_directory(destination, part)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=3000)
