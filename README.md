# Vouched

Trusted network

# Getting Started

These instruction will help you to setup a local Vouched application on development mode

## Prerequisites

```
XCode
Flutter
Node
Firebase
```

## Installing and Setting up

1. Downlaod XCode on your MacOS (Mac App Store)
2. Install Flutter ([https://flutter.dev/](https://flutter.dev/))
3. Install Node.JS ([https://nodejs.org/en/](https://nodejs.org/en/))
4. Setup your Firebase account and create a new project ([https://firebase.google.com/](https://firebase.google.com/))
5. Generate a new iOS app on Firebase console (more instructions on [https://firebase.google.com/docs/flutter/setup](https://firebase.google.com/docs/flutter/setup))
6. For Node.JS scripts generate a new admin service account (more instructions on [https://firebase.google.com/docs/admin/setup](https://firebase.google.com/docs/admin/setup))

## Authentication methods

> At the moment only the phone authentication method is available

1. On Firebase -> Authentication -> Sign in method, turn on the Phone provider
2. Create a phone number for test and verification code (for istance `+1 650-555-1234` and code `123456`, make sure that number is available for test for avoid future conflicts with real numbers)

## Google Service file (`GoogleService-Info.plist`)

On Firebase follow the instructions from [https://firebase.google.com/docs/flutter/setup](https://firebase.google.com/docs/flutter/setup) and you should generate a file named `GoogleService-Info.plist` this file should be put on directory `vouched/ios/Runner/GoogleService-Info.plist`

## Loading Users and Job Examples

Job examples and users can be loaded into the Firebase throught the scripts `scripts/job-loader` directory

### Create users

```bash
npm run create-users
```

### Create posts

```bash
npm run create-posts
```

### VSCode and Flutter

Install Flutter plugins for `VSCode` and you should be ready to run, click `Debug -> Start Debugging`

# Build with

- [Flutter Framwork](https://flutter.dev)
- [NodeJS](https://nodejs.org/en/)
- [Firebase](https://firebase.google.com/)

# Authors

- Rodrigo Serviuc Pavezi - rodrigopavezi
- Eduardo Nunes Pereira - eduardonunesp
- Arya Soltanieh - lostcodingsomewhere

# License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
