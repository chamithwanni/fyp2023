import os

from keras.models import model_from_json
import cv2
import numpy as np

def emotion_test(file):
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

    # load image
    image = cv2.imread(file)

    # preprocess image
    gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    face_detector = cv2.CascadeClassifier(
        'C:/Users/CHAMITH/PycharmProjects/emotionDetectionAPI/haarcascades/haarcascade_frontalface_default.xml')
    faces = face_detector.detectMultiScale(gray_image, scaleFactor=1.3, minNeighbors=5)
    if len(faces) == 0:
        print("No faces found in the image!")
        emotion = 'No faces'
        return emotion
    for (x, y, w, h) in faces:
        cv2.rectangle(image, (x, y - 50), (x + w, y + h + 10), (0, 255, 0), 4)
        gray_roi = gray_image[y:y + h, x:x + w]
        cropped_img = np.expand_dims(np.expand_dims(cv2.resize(gray_roi, (48, 48)), -1), 0)

        # predict emotions
        predict_emotion = emotion_model.predict(cropped_img)
        max_index = int(np.argmax(predict_emotion))
        cv2.putText(image, emotion_dict[max_index], (x + 5, y - 20), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 0, 0), 2,
                    cv2.LINE_AA)

    predict_emotion = emotion_model.predict(cropped_img)
    max_index = int(np.argmax(predict_emotion))
    emotion = emotion_dict[max_index]
    return emotion

if __name__ == "__main__":
    emotion_test()