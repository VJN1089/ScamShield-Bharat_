# ScamShield-Bharat_
# 🛡️ ScamShield Bharat

### Pause. Verify. Protect.

ScamShield Bharat is a digital investor-safety assistant designed to help users recognize warning signals in suspicious investment messages and screenshots.

## Problem

Investment scams can use urgency, guaranteed-return claims, fake authority claims, social-media groups, unknown applications and withdrawal-fee requests to manipulate users.

These risks can be especially difficult for first-time investors, elderly users and people who prefer regional languages.

## Solution

ScamShield Bharat provides a simple safety workflow:

**Detect → Explain → Verify → Protect**

Users can:

* Paste suspicious investment messages.
* Upload screenshots.
* Extract text using OCR.
* Identify potential warning signals.
* View an explainable risk level.
* Receive safety guidance.
* View guidance in English, Hindi or Kannada.

## Key Features

### 💬 Message Scanner

Analyzes suspicious investment messages and identifies potential warning patterns.

### 📷 Screenshot Scanner

Uses OCR to extract visible text from WhatsApp, SMS, Telegram or social-media screenshots and analyzes the extracted content.

### 🚩 Explainable Warning Signals

The system identifies signals such as:

* Guaranteed returns
* Urgency
* Social-media investment groups
* Unknown APKs
* Withdrawal fees
* Authority claims
* Payment requests

### 🇮🇳 Bharat-First Support

Safety guidance is available in:

* English
* Hindi
* Kannada

## Privacy & Safety

The prototype is designed around data minimization.

It does not ask users for:

* OTPs
* UPI PINs
* Banking passwords
* Card PINs

The system does not provide stock tips, buy/sell/hold recommendations or price predictions.

## Technology Stack

* Python
* Google Colab
* Gradio
* EasyOCR
* Pillow
* NumPy
* Regular-expression based text processing

## Architecture

```text
User Input
    ↓
Message / Screenshot
    ↓
OCR for Screenshots
    ↓
Text Processing
    ↓
Warning-Signal Detection
    ↓
Risk Classification
    ↓
Explainable Safety Guidance
    ↓
English / Hindi / Kannada
```

## Important Limitation

ScamShield Bharat is a safety-assistance prototype. It identifies potential warning signals but does not determine with certainty whether a message is fraudulent.

Users should independently verify important financial claims.

## Future Scope

* Voice input and output
* Scam Journey education
* More Indian languages
* Context-aware AI analysis
* URL and domain analysis
* Official verification guidance
* Accessibility improvements

## Running the Prototype

Open the Google Colab notebook and run the cells.

The final cell launches the Gradio interface.

## Public-Good Focus

ScamShield Bharat is designed for investor protection and scam resilience rather than investment promotion or trading.
