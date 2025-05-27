# CAPTCHA Solver using CNN

CAPTCHAs help prevent bots from abusing web services, but how secure are they really against machine learning? This project explores that question by training a Convolutional Neural Network (CNN) to **solve 5-character CAPTCHA puzzles** — with up to **86% accuracy on outer characters**.

---

## Overview

This project builds a multi-output CNN to recognize alphanumeric CAPTCHA images with 5 characters, each distorted with noise and varying fonts. We use image preprocessing, character-level one-hot encoding, and a custom CNN architecture to classify each character individually.

- **Goal**: Achieve ≥85% accuracy on CAPTCHA character prediction  
- **Model Input**: RGB CAPTCHA images of shape `(64, 128, 3)`  
- **Model Output**: 5-character prediction (`char_0` to `char_4`)

---

## Key Features

- Built with **TensorFlow/Keras**
- Preprocessing with image normalization + one-hot encoding
- Multi-output CNN architecture (5 softmax heads)
- Tracks per-character accuracy
- Includes training/validation loss plots

---

## Image Processing & Label Encoding

```python
# Normalize image pixel values to range [0, 1]
cap_X_train = np.array([np.array(Image.open(img).resize((128, 64))) / 255.0 for img in cap_X_train])
cap_X_test = np.array([np.array(Image.open(img).resize((128, 64))) / 255.0 for img in cap_X_test])

# One-hot encode labels
char_to_int = {char: idx for idx, char in enumerate('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz')}
cap_y_train_encoded = [[char_to_int[char] for char in label] for label in cap_y_train]
cap_y_test_encoded = [[char_to_int[char] for char in label] for label in cap_y_test]

# Then one-hot encode each character
cap_y_train = np.array([to_categorical(label, num_classes=len(char_to_int)) for label in cap_y_train_encoded])
cap_y_test = np.array([to_categorical(label, num_classes=len(char_to_int)) for label in cap_y_test_encoded])
```

---

## Model Architecture

```python
captcha_length = 5  # If your captchas are 5 characters
num_classes = len(char_to_int)  # Should be 62 if using 0-9, A-Z, a-z

inputs = keras.Input(shape=(64, 128, 3))
x = keras.layers.Conv2D(32, (3, 3), padding='same', activation='relu')(inputs)
x = keras.layers.BatchNormalization()(x)
x = keras.layers.MaxPooling2D((2, 2))(x)

x = keras.layers.Conv2D(64, (3, 3), padding='same', activation='relu')(x)
x = keras.layers.BatchNormalization()(x)
x = keras.layers.MaxPooling2D((2, 2))(x)

x = keras.layers.Conv2D(128, (3, 3), padding='same', activation='relu')(x)
x = keras.layers.BatchNormalization()(x)
x = keras.layers.MaxPooling2D((2, 2))(x)

x = keras.layers.Conv2D(256, (3, 3), padding='same', activation='relu')(x)
x = keras.layers.BatchNormalization()(x)
x = keras.layers.SpatialDropout2D(0.3)(x)
#x = keras.layers.GlobalMaxPooling2D()(x)
x = keras.layers.GlobalAveragePooling2D()(x)

x = keras.layers.Dropout(0.5)(x)

# One Dense output per character
outputs = [Dense(num_classes, activation='softmax', name=f'char_{i}')(x) for i in range(captcha_length)]

model = keras.Model(inputs=inputs, outputs=outputs)
model.compile(
    optimizer='adam',
    loss='categorical_crossentropy',
    metrics=['accuracy'] * captcha_length
)
```

---

## Model Performance

| Character Position | Accuracy | Loss |
|--------------------|----------|------|
| `char_0`           | 86%      | 0.40 |
| `char_1`           | 60%      | 1.37 |
| `char_2`           | 44%      | 1.86 |
| `char_3`           | 60%      | 1.37 |
| `char_4`           | 86%      | 0.40 |

> The middle characters (`char_1`, `char_2`, `char_3`) show lower accuracy — likely due to overlapping and image resizing artifacts.

---

## Training Visualization
![Training vs Validation Loss](plots/Training%20and%20validation%20Loss%2C%20Per-Character%20Accuracy%20per%20Epoch.png)

---

## Sample Predictions

![Model Predictions Examples](plots/Model%20Predictions%20Examples.png)

| Input CAPTCHA | Predicted | Notes |
|---------------|-----------|-------|
| `3USsE`       | `3UssE`   | ✅ Correct |
| `wjCwa`       | `wjwCa`   | Case error on char_2 |

---

## Future Work

- Implement sequence-based prediction (treat full CAPTCHA as one label)

- Apply model to break Google reCAPTCHA v2

- Add pre-segmentation step to isolate characters before classification

---

References
- Plesner et al. (2024). Breaking reCAPTCHAv2 using YOLO.

- Alqahtani & Alsulaiman (2020). ML vs reCAPTCHAs: A case study.

- Bostik & Klecka (2018). CAPTCHA recognition with pattern neural networks.

---
