import json
import random

def lambda_handler(event, context):
    # Get the user's guess from the event
    try:
        user_guess = int(event.get('guess', 0))
    except ValueError:
        return {
            'statusCode': 400,
            'body': json.dumps({
                'message': 'Please provide a valid number as your guess'
            })
        }

    # Generate a random number between 1 and 10
    target_number = random.randint(1, 10)

    # Compare the guess with the target number
    if user_guess == target_number:
        message = f"Congratulations! You guessed the number {target_number} correctly!"
    elif user_guess < target_number:
        message = f"Too low! The number was {target_number}. Try again!"
    else:
        message = f"Too high! The number was {target_number}. Try again!"

    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': message,
            'your_guess': user_guess,
            'target_number': target_number
        })
    }
