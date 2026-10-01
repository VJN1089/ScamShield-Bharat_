# ============================================================
# 🛡️ SCAMSHIELD BHARAT
# Digital Fraud & Scam Resilience
# Google Colab - Complete MVP
# ============================================================

# ------------------------------------------------------------
# 1. INSTALL REQUIRED LIBRARIES
# ------------------------------------------------------------

!pip install -q gradio easyocr pillow


# ------------------------------------------------------------
# 2. IMPORT LIBRARIES
# ------------------------------------------------------------

import re
import easyocr
import gradio as gr
import numpy as np

from PIL import Image


# ------------------------------------------------------------
# 3. START OCR ENGINE
# ------------------------------------------------------------

print("Starting ScamShield Bharat...")

reader = easyocr.Reader(
    ['en'],
    gpu=False
)

print("✅ OCR engine ready")


# ------------------------------------------------------------
# 4. SCAM WARNING PATTERNS
# ------------------------------------------------------------

RED_FLAGS = {

    "Guaranteed Return": [
        "guaranteed return",
        "guaranteed profit",
        "fixed return",
        "assured return",
        "double your money",
        "money double",
        "guaranteed 40%",
        "guaranteed 50%"
    ],

    "Urgency": [
        "act now",
        "today only",
        "limited time",
        "only 3 slots",
        "only 5 slots",
        "urgent",
        "last chance",
        "expires today",
        "do it today"
    ],

    "Social Media Investment Group": [
        "telegram",
        "whatsapp group",
        "vip group",
        "signal group",
        "investment group",
        "trading group"
    ],

    "Unknown App": [
        "download apk",
        "install apk",
        "trading apk",
        "unknown app",
        "download our app",
        "install our app"
    ],

    "Withdrawal Fee": [
        "withdrawal fee",
        "pay tax",
        "processing fee",
        "unlock withdrawal",
        "withdraw fee",
        "withdrawal tax",
        "pay a fee"
    ],

    "Authority Claim": [
        "sebi approved",
        "sebi registered",
        "government approved",
        "official sebi",
        "rbi approved",
        "rbi registered",
        "government registered"
    ],

    "Payment Request": [
        "deposit",
        "transfer money",
        "send money",
        "upi payment",
        "send payment",
        "pay now",
        "make payment"
    ]
}


# ------------------------------------------------------------
# 5. TEXT CLEANING
# ------------------------------------------------------------

def clean_text(text):

    text = str(text).lower()

    text = re.sub(
        r"\s+",
        " ",
        text
    )

    return text.strip()


# ------------------------------------------------------------
# 6. SCAM ANALYSIS ENGINE
# ------------------------------------------------------------

def analyze_text(text):

    text = clean_text(text)

    detected_flags = []

    for category, keywords in RED_FLAGS.items():

        for keyword in keywords:

            if keyword in text:

                detected_flags.append(category)

                break


    count = len(detected_flags)


    # Risk classification
    if count >= 4:

        level = "HIGH CONCERN"

    elif count >= 2:

        level = "CAUTION"

    else:

        level = "LOW CONCERN"


    return {
        "level": level,
        "flags": detected_flags,
        "count": count
    }


# ------------------------------------------------------------
# 7. MULTILINGUAL SAFETY CONTENT
# ------------------------------------------------------------

LANGUAGES = {

    "English": {

        "high":
            "🚨 HIGH CONCERN",

        "caution":
            "🟡 CAUTION",

        "low":
            "🟢 LOW CONCERN",

        "signals":
            "🚩 WARNING SIGNALS",

        "actions":
            "🛡️ WHAT YOU SHOULD DO",

        "no_transfer":
            "• Do not transfer money immediately.",

        "verify":
            "• Verify the claim independently.",

        "apk":
            "• Do not install unknown APK files.",

        "credentials":
            "• Never share OTP, PIN or password.",

        "uncertainty":
            "⚠️ This is a safety aid, not a definitive fraud verdict."
    },


    "Hindi": {

        "high":
            "🚨 उच्च सावधानी आवश्यक",

        "caution":
            "🟡 सावधान रहें",

        "low":
            "🟢 कम चेतावनी संकेत",

        "signals":
            "🚩 चेतावनी संकेत",

        "actions":
            "🛡️ आपको क्या करना चाहिए",

        "no_transfer":
            "• तुरंत पैसे ट्रांसफर न करें।",

        "verify":
            "• जानकारी की स्वतंत्र रूप से पुष्टि करें।",

        "apk":
            "• अनजान APK इंस्टॉल न करें।",

        "credentials":
            "• OTP, PIN या पासवर्ड कभी साझा न करें।",

        "uncertainty":
            "⚠️ यह केवल सुरक्षा सहायता है, धोखाधड़ी का निश्चित निर्णय नहीं।"
    },


    "Kannada": {

        "high":
            "🚨 ಹೆಚ್ಚಿನ ಎಚ್ಚರಿಕೆ",

        "caution":
            "🟡 ಎಚ್ಚರಿಕೆಯಿಂದಿರಿ",

        "low":
            "🟢 ಕಡಿಮೆ ಎಚ್ಚರಿಕೆ ಸೂಚನೆಗಳು",

        "signals":
            "🚩 ಎಚ್ಚರಿಕೆ ಸೂಚನೆಗಳು",

        "actions":
            "🛡️ ನೀವು ಏನು ಮಾಡಬೇಕು",

        "no_transfer":
            "• ತಕ್ಷಣ ಹಣ ವರ್ಗಾವಣೆ ಮಾಡಬೇಡಿ.",

        "verify":
            "• ಮಾಹಿತಿಯನ್ನು ಸ್ವತಂತ್ರವಾಗಿ ಪರಿಶೀಲಿಸಿ.",

        "apk":
            "• ಅಪರಿಚಿತ APK ಅನ್ನು ಸ್ಥಾಪಿಸಬೇಡಿ.",

        "credentials":
            "• OTP, PIN ಅಥವಾ ಪಾಸ್‌ವರ್ಡ್ ಹಂಚಿಕೊಳ್ಳಬೇಡಿ.",

        "uncertainty":
            "⚠️ ಇದು ಸುರಕ್ಷತಾ ಸಹಾಯ ಮಾತ್ರ, ಮೋಸದ ಅಂತಿಮ ನಿರ್ಧಾರವಲ್ಲ."
    }
}


# ------------------------------------------------------------
# 8. GENERATE MULTILINGUAL REPORT
# ------------------------------------------------------------

def generate_report(result, language):

    lang = LANGUAGES.get(
        language,
        LANGUAGES["English"]
    )

    # Risk level
    if result["level"] == "HIGH CONCERN":

        output = lang["high"] + "\n\n"

    elif result["level"] == "CAUTION":

        output = lang["caution"] + "\n\n"

    else:

        output = lang["low"] + "\n\n"


    # Number of signals
    output += (
        "Warning signals detected: "
        + str(result["count"])
        + "\n\n"
    )


    # Warning signals
    output += lang["signals"] + "\n\n"


    if result["flags"]:

        for flag in result["flags"]:

            output += "• " + flag + "\n"

    else:

        output += (
            "• No known warning pattern detected.\n"
        )


    # Safety actions
    output += "\n"
    output += lang["actions"]
    output += "\n\n"

    output += lang["no_transfer"] + "\n"
    output += lang["verify"] + "\n"
    output += lang["apk"] + "\n"
    output += lang["credentials"] + "\n"


    # Disclaimer
    output += "\n"
    output += lang["uncertainty"]


    return output


# ------------------------------------------------------------
# 9. MESSAGE SCANNER
# ------------------------------------------------------------

def scan_message(message, language):

    if message is None or not message.strip():

        return (
            "⚠️ Please enter a suspicious message "
            "before scanning."
        )


    result = analyze_text(message)

    report = generate_report(
        result,
        language
    )


    return report


# ------------------------------------------------------------
# 10. OCR - EXTRACT TEXT FROM SCREENSHOT
# ------------------------------------------------------------

def extract_text_from_image(image):

    if image is None:

        return ""


    image_array = np.array(image)

    results = reader.readtext(
        image_array
    )

    extracted_text = []


    for result in results:

        text = result[1]

        extracted_text.append(text)


    return "\n".join(
        extracted_text
    )


# ------------------------------------------------------------
# 11. SCREENSHOT SCANNER
# ------------------------------------------------------------

def analyze_screenshot(image, language):

    if image is None:

        return (
            "⚠️ Please upload a screenshot."
        )


    # OCR
    extracted_text = extract_text_from_image(
        image
    )


    if not extracted_text.strip():

        return (
            "⚠️ No readable text was detected "
            "in the screenshot."
        )


    # Scam analysis
    result = analyze_text(
        extracted_text
    )


    # Generate normal report
    report = generate_report(
        result,
        language
    )


    # Add extracted text
    report += "\n\n"
    report += "📄 EXTRACTED SCREENSHOT TEXT"
    report += "\n\n"
    report += extracted_text


    return report


# ------------------------------------------------------------
# 12. SAMPLE MESSAGES FOR DEMO
# ------------------------------------------------------------

HIGH_RISK_EXAMPLE = """
Congratulations! You have been selected for our VIP
Investment Group.

Our expert team is offering a GUARANTEED 40% RETURN
in just 7 days.

This opportunity is available TODAY ONLY.
Only 3 slots are remaining!

We are SEBI approved and 100% safe.

Deposit ₹10,000 through UPI to activate your account.

Download our special trading APK from the link below.

Your profit is already showing in your account.

To withdraw ₹50,000, you must first pay ₹5,000
as a withdrawal tax and processing fee.

Act NOW before your account expires!
"""


CAUTION_EXAMPLE = """
I received an investment-related message from someone
I don't know. They asked me to join a Telegram group
and promised high returns if I deposit money today.
"""


NORMAL_EXAMPLE = """
I want to learn more about investing and understand
the risks before making any financial decision.
"""


# ------------------------------------------------------------
# 13. CREATE GRADIO APPLICATION
# ------------------------------------------------------------

with gr.Blocks(
    title="ScamShield Bharat"
) as demo:


    # --------------------------------------------------------
    # HEADER
    # --------------------------------------------------------

    gr.Markdown(
        """
        # 🛡️ ScamShield Bharat

        ### Pause. Verify. Protect.

        **A digital safety assistant for suspicious
        investment messages and scam screenshots.**

        Detect warning signals • Understand the risk •
        Take safer next steps
        """
    )


    gr.Markdown(
        """
        ---
        """
    )


    # --------------------------------------------------------
    # LANGUAGE SELECTOR
    # --------------------------------------------------------

    language = gr.Dropdown(

        choices=[
            "English",
            "Hindi",
            "Kannada"
        ],

        value="English",

        label="🌐 Choose Your Language"
    )


    # --------------------------------------------------------
    # TABS
    # --------------------------------------------------------

    with gr.Tabs():


        # ====================================================
        # TAB 1 - MESSAGE SCANNER
        # ====================================================

        with gr.Tab(
            "💬 Message Scanner"
        ):

            gr.Markdown(
                """
                ### Analyze a suspicious message

                Paste a message received through
                WhatsApp, Telegram, SMS, email or social media.
                """
            )


            message = gr.Textbox(

                lines=10,

                placeholder=(
                    "Paste suspicious investment message here..."
                ),

                label="📩 Suspicious Message"
            )


            message_button = gr.Button(
                "🔍 Analyze Message",
                variant="primary"
            )


            message_output = gr.Textbox(

                lines=20,

                label="🛡️ ScamShield Analysis"
            )


            message_button.click(

                fn=scan_message,

                inputs=[
                    message,
                    language
                ],

                outputs=message_output
            )


            gr.Examples(

                examples=[

                    [
                        HIGH_RISK_EXAMPLE,
                        "English"
                    ],

                    [
                        CAUTION_EXAMPLE,
                        "English"
                    ],

                    [
                        NORMAL_EXAMPLE,
                        "English"
                    ]

                ],

                inputs=[
                    message,
                    language
                ],

                label="🧪 Try Demo Messages"
            )


        # ====================================================
        # TAB 2 - SCREENSHOT SCANNER
        # ====================================================

        with gr.Tab(
            "📷 Screenshot Scanner"
        ):

            gr.Markdown(
                """
                ### Scan a suspicious screenshot

                Upload a WhatsApp, SMS, Telegram or
                social-media screenshot.

                ScamShield uses OCR to extract the visible
                text and analyze warning signals.
                """
            )


            screenshot = gr.Image(

                type="pil",

                label=(
                    "📷 Upload Suspicious Screenshot"
                )
            )


            screenshot_button = gr.Button(
                "🔍 Scan Screenshot",
                variant="primary"
            )


            screenshot_output = gr.Textbox(

                lines=30,

                label="🛡️ Screenshot Analysis"
            )


            screenshot_button.click(

                fn=analyze_screenshot,

                inputs=[
                    screenshot,
                    language
                ],

                outputs=screenshot_output
            )


        # ====================================================
        # TAB 3 - SAFETY GUIDE
        # ====================================================

        with gr.Tab(
            "🛡️ Safety Guide"
        ):

            gr.Markdown(
                """
                # 🛡️ Scam Safety Guide

                ### Before sending money:

                **1️⃣ Pause**

                Don't act immediately because a message
                creates urgency.

                **2️⃣ Verify**

                Independently verify the person,
                organization or claim.

                **3️⃣ Protect**

                Never share OTP, PIN, password or
                other authentication information.

                **4️⃣ Avoid Unknown Apps**

                Don't install APK files or applications
                sent by unknown people.

                **5️⃣ Question Guaranteed Returns**

                Be cautious about messages promising
                guaranteed or unusually high returns.

                **6️⃣ Don't Pay to Unlock Withdrawals**

                Requests for additional fees, taxes or
                payments to release supposed profits
                are important warning signs.

                ---

                ### 🚨 Remember

                ScamShield identifies warning patterns.
                It does **not** determine fraud with
                certainty.

                Always verify important financial claims
                independently.
                """
            )


    # --------------------------------------------------------
    # PRIVACY / GUARDRAILS
    # --------------------------------------------------------

    gr.Markdown(
        """
        ---

        ## 🔐 Privacy & Safety

        ScamShield Bharat is designed around
        data minimization.

        ❌ No OTP collection
        ❌ No UPI PIN collection
        ❌ No banking password collection
        ❌ No investment recommendations
        ❌ No stock-price predictions
        ❌ No buy/sell/hold recommendations

        ### Our goal:

        **Help users pause, understand warning signs,
        verify information and protect themselves.**

        ⚠️ ScamShield Bharat is a safety-assistance
        prototype and is not a definitive fraud detector.
        """
    )


# ------------------------------------------------------------
# 14. LAUNCH APPLICATION
# ------------------------------------------------------------

print()
print("=" * 60)
print("🛡️ SCAMSHIELD BHARAT IS READY")
print("=" * 60)
print()
print("Launching web application...")
print()

demo.launch(
    share=True,
    debug=False
)
