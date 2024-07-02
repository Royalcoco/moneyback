import pymysql
import pandas as pd
import numpy as np
from PIL import Image, ImageFilter
from sklearn.ensemble import IsolationForest
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, accuracy_score
import os
import zlib
import random

# Connexion à la base de données
connection = pymysql.connect(
    host='localhost',
    user='votre_utilisateur',
    password='votre_mot_de_passe',
    database='PlatformeOuverte'
)

def read_excel_and_insert_to_db(excel_file):
    """Read data from an Excel file and insert it into the database."""
    df = pd.read_excel(excel_file)
    cursor = connection.cursor()

    for index, row in df.iterrows():
        sql = "INSERT INTO Frames (FrameNumber, SignalData) VALUES (%s, %s)"
        cursor.execute(sql, (row['FrameNumber'], row['SignalData']))

    connection.commit()
    cursor.close()

def read_db_and_write_to_excel(excel_file):
    """Read data from the database and write it to an Excel file."""
    sql = "SELECT * FROM Frames"
    df = pd.read_sql(sql, connection)
    
    with pd.ExcelWriter(excel_file, engine='openpyxl') as writer:
        df.to_excel(writer, index=False, sheet_name='Frames')

def save_frame_to_db(frame_number, image_path, cursor):
    """Save a frame to the database."""
    with open(image_path, 'rb') as f:
        image_data = f.read()

    sql = "INSERT INTO Frames (FrameNumber, ImageData) VALUES (%s, %s)"
    cursor.execute(sql, (frame_number, image_data))

def process_and_save_frames(num_frames, image_directory):
    """Process and save frames to the database."""
    cursor = connection.cursor()

    for frame_number in range(1, num_frames + 1):
        image_path = os.path.join(image_directory, f'frame_{frame_number}.png')
        image = Image.open(image_path)

        # Reduce polarization by half
        np_image = np.array(image) // 2
        polarized_image = Image.fromarray(np_image)

        # Apply Gaussian blur filter
        blurred_image = polarized_image.filter(ImageFilter.GaussianBlur(radius=2))

        # Save the processed image
        processed_image_path = os.path.join(image_directory, f'processed_frame_{frame_number}.png')
        blurred_image.save(processed_image_path)

        # Save the image to the database
        save_frame_to_db(frame_number, processed_image_path, cursor)

    connection.commit()
    cursor.close()

def analyze_frame_data(frame_data):
    """Analyze frame data using a machine learning model."""
    # Example analysis using a fake AI model
    result = "Fake analysis result"
    return result

def perform_analysis_and_store_results():
    """Perform analysis on frame data and store the results."""
    cursor = connection.cursor()

    sql = "SELECT * FROM Frames"
    cursor.execute(sql)
    frames = cursor.fetchall()

    for frame in frames:
        frame_id = frame['FrameID']
        frame_data = frame['SignalData']

        # Analyze frame data
        analysis_result = analyze_frame_data(frame_data)

        # Insert analysis results into the database
        sql = "INSERT INTO AnalysisResults (FrameID, ResultData) VALUES (%s, %s)"
        cursor.execute(sql, (frame_id, analysis_result))

    connection.commit()
    cursor.close()

def detect_anomalies_in_network_traffic(data_file):
    """Detect anomalies in network traffic using Isolation Forest."""
    data = pd.read_csv(data_file)
    features = ['feature1', 'feature2', 'feature3', 'featureN']
    X = data[features]
    y = data['label']  # 1 for normal, -1 for anomaly

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

    model = IsolationForest(contamination=0.1, random_state=42)
    model.fit(X_train)

    y_pred = model.predict(X_test)

    print(classification_report(y_test, y_pred, target_names=['Normal', 'Anomaly']))
    print('Accuracy:', accuracy_score(y_test, y_pred))

def create_large_decompressed_file(output_file, multiplier=100):
    """Create a larger decompressed file for testing."""
    sql = "SELECT * FROM Frames"
    df = pd.read_sql(sql, connection)
    
    original_size = df.memory_usage(index=True).sum()
    increased_size = original_size * multiplier

    with open(output_file, 'wb') as f:
        for _ in range(multiplier):
            f.write(df.to_csv(index=False).encode())

    print(f"Original size: {original_size} bytes")
    print(f"Increased size: {increased_size} bytes")

def compress_file(input_file, output_file):
    """Compress a file using zlib."""
    with open(input_file, 'rb') as f:
        data = f.read()
    
    compressed_data = zlib.compress(data)
    with open(output_file, 'wb') as f:
        f.write(compressed_data)

def decompress_file(input_file, output_file):
    """Decompress a file using zlib."""
    with open(input_file, 'rb') as f:
        compressed_data = f.read()
    
    data = zlib.decompress(compressed_data)
    with open(output_file, 'wb') as f:
        f.write(data)

def randomize_data_order(data):
    """Randomize the order of the data."""
    indices = list(range(len(data)))
    random.shuffle(indices)
    return data.iloc[indices]

def insert_radio_burst_order():
    """Insert radio burst order data."""
    # This function needs to be implemented based on the specifics of radio burst order data
    pass

# Example usage
read_excel_and_insert_to_db('/path/to/your/input_excel_file.xlsx')
read_db_and_write_to_excel('/path/to/your/output_excel_file.xlsx')
process_and_save_frames(3000, '/path/to/your/images')
perform_analysis_and_store_results()
detect_anomalies_in_network_traffic('/path/to/network_traffic_data.csv')
create_large_decompressed_file('/path/to/large_output_file.csv')

compress_file('/path/to/large_output_file.csv', '/path/to/compressed_output_file.bin')
decompress_file('/path/to/compressed_output_file.bin', '/path/to/decompressed_output_file.csv')

os.remove('/path/to/large_output_file.csv')
os.remove('/path/to/compressed_output_file.bin')
os.remove('/path/to/decompressed_output_file.csv')

print("Toutes les opérations ont été effectuées avec succès !")
