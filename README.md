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

| Input CAPTCHA | Predicted | Actual | Notes |
|---------------|-----------|--------|-------|
| `wjCwa`       | `wjwCa`   | `wjCwa`| Case error on char_2 |
| `aB1cD`       | `aB1cD`   | `aB1cD`| ✅ Correct |

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
