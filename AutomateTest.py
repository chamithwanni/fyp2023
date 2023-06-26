import os
import cv2
import numpy as np
from keras.models import model_from_json
from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten, Conv2D, MaxPooling2D
import matplotlib.pyplot as plt

def display_emotion(images_dir):
    emotion_dict = {
        0: "Angry",
        1: "Disgusted",
        2: "Fearful",
        3: "Happy",
        4: "Natural",
        5: "Sad",
        6: "Surprised"
    }

    # create model and load json file
    json_file = open('C:/Users/CHAMITH/PycharmProjects/emotionDetectionAPI/model/model.json', 'r')
    load_json_model = json_file.read()
    json_file.close()
    emotion_model = model_from_json(load_json_model)

    # load weights into new model
    emotion_model.load_weights("C:/Users/CHAMITH/PycharmProjects/emotionDetectionAPI/model/model.h5")
    print("Model loaded from disk...")

    # load images from directory
    images = [f for f in os.listdir(images_dir) if os.path.isfile(os.path.join(images_dir, f))]

    # iterate over the images and predict the emotion
    predictions = []
    for image_path in images:
        image = cv2.imread(os.path.join(images_dir, image_path))
        gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        face_detector = cv2.CascadeClassifier(
            'C:/Users/CHAMITH/PycharmProjects/emotionDetectionAPI/haarcascades/haarcascade_frontalface_default.xml')
        faces = face_detector.detectMultiScale(gray_image, scaleFactor=1.3, minNeighbors=5)
        if len(faces) == 0:
            print(f"No faces found in {image_path}!")
            predicted_emotion = 'No faces'
        else:
            for (x, y, w, h) in faces:
                gray_roi = gray_image[y:y + h, x:x + w]
                cropped_img = np.expand_dims(np.expand_dims(cv2.resize(gray_roi, (48, 48)), -1), 0)

                # predict emotions
                predict_emotion = emotion_model.predict(cropped_img)
                max_index = int(np.argmax(predict_emotion))
                predicted_emotion = emotion_dict[max_index]
        predictions.append(predicted_emotion)

    # display the images and their predicted emotions in a grid view
    n_cols = 4
    n_rows = int(np.ceil(len(images) / n_cols))
    fig, axs = plt.subplots(n_rows, n_cols, figsize=(10, 10))
    axs = axs.flatten()
    for i, (image_path, predicted_emotion) in enumerate(zip(images, predictions)):
        image = cv2.imread(os.path.join(images_dir, image_path))
        axs[i].imshow(cv2.cvtColor(image, cv2.COLOR_BGR2RGB))
        axs[i].set_title(predicted_emotion)
        axs[i].axis('off')
    plt.show()

if __name__ == "__main__":
   display_emotion('./test/sad')