import re

RED_FLAGS = {
    "Guaranteed Return": [
        "guaranteed return",
        "guaranteed profit",
        "fixed return",
        "assured return",
        "double your money"
    ],

    "Urgency": [
        "act now",
        "today only",
        "limited time",
        "urgent",
        "last chance"
    ],

    "Social Media Investment Group": [
        "telegram",
        "whatsapp group",
        "vip group",
        "investment group",
        "trading group"
    ],

    "Unknown App": [
        "download apk",
        "install apk",
        "trading apk",
        "unknown app"
    ],

    "Withdrawal Fee": [
        "withdrawal fee",
        "pay tax",
        "processing fee",
        "unlock withdrawal",
        "withdrawal tax"
    ],

    "Authority Claim": [
        "sebi approved",
        "sebi registered",
        "rbi approved",
        "government approved"
    ],

    "Payment Request": [
        "deposit",
        "transfer money",
        "send money",
        "upi payment",
        "pay now"
    ]
}


def clean_text(text):
    text = str(text).lower()
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def analyze_text(text):

    text = clean_text(text)

    flags = []

    for category, keywords in RED_FLAGS.items():

        for keyword in keywords:

            if keyword in text:
                flags.append(category)
                break


    count = len(flags)


    if count >= 4:
        level = "HIGH CONCERN"

    elif count >= 2:
        level = "CAUTION"

    else:
        level = "LOW CONCERN"


    explanation = (
        "Multiple warning patterns may indicate pressure, "
        "unverified claims, payment requests or other risky behavior."
    )


    if count == 0:

        explanation = (
            "No known warning pattern was detected. "
            "However, absence of a detected pattern does not prove that "
            "a message is safe."
        )


    actions = [

        "Do not transfer money immediately.",

        "Verify the person or organization independently.",

        "Do not install unknown APK files.",

        "Never share OTP, PIN or password.",

        "Be cautious about guaranteed or unusually high returns."
    ]


    return {

        "level": level,

        "flags": flags,

        "count": count,

        "explanation": explanation,

        "actions": actions
    }
