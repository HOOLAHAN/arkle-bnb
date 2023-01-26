# Project specification

We would like a web application that allows users to list spaces they have available, and to hire spaces for the night.

### Headline specifications

- Any signed-up user can list a new space.
- Users can list multiple spaces.
- Users should be able to name their space, provide a short description of the space, and a price per night.
- Users should be able to offer a range of dates where their space is available.
- Any signed-up user can request to hire any space for one night, and this should be approved by the user that owns that space.
- Nights for which a space has already been booked should not be available for users to book that space.
- Until a user has confirmed a booking request, that space can still be booked for that night.

### Nice-to-haves

- Users should receive an email whenever one of the following happens:
 - They sign up
 - They create a space
 - They update a space
 - A user requests to book their space
 - They confirm a request
 - They request to book a space
 - Their request to book a space is confirmed
 - Their request to book a space is denied
- Users should receive a text message to a provided number whenever one of the following happens:
 - A user requests to book their space
 - Their request to book a space is confirmed
 - Their request to book a space is denied
- A ‘chat’ functionality once a space has been booked, allowing users whose space-booking request has been confirmed to chat with the user that owns that space
- Basic payment implementation though Stripe.

## Setup

```bash
# Install gems
bundle install

# Set up environment variables
echo "export TWILIO_ACCOUNT_SID='XXXXXXXXXXXXXXX'" > twilio.env
echo "export TWILIO_AUTH_TOKEN='XXXXXXXXXXXXX'" >> twilio.env
echo "export IH_MOBILE='XXXXXXXXXXX'" >> twilio.env
echo "export TWILIO_NUMBER='XXXXXXXX'" >> twilio.env
source ./twilio.env

# Run the tests
rspec

# Run the server (better to do this in a separate terminal)
rackup

# In the web browswer navigate to:
http://localhost:9292/
```
## Demo

### Signup page:
![signup](https://github.com/HOOLAHAN/arkle-bnb/blob/main/images/signup.png)

### Login page:
![login page](https://github.com/HOOLAHAN/arkle-bnb/blob/main/images/login.png)

### Menu page
![Menu](https://github.com/HOOLAHAN/arkle-bnb/blob/main/images/menu.png)

### Booking page
![Booking](https://github.com/HOOLAHAN/arkle-bnb/blob/main/images/book-a-space.png)

### Account page
![My-Account](https://github.com/HOOLAHAN/arkle-bnb/blob/main/images/my-account-1.png)
![My-Account](https://github.com/HOOLAHAN/arkle-bnb/blob/main/images/my-account-2.png)

### Messages Page
![My-Messages](https://github.com/HOOLAHAN/arkle-bnb/blob/main/images/my-messages-1.png)
![My-Messages](https://github.com/HOOLAHAN/arkle-bnb/blob/main/images/my-messages-2.png)
