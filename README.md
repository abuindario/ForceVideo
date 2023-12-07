# Force Video - a Salesforce App
Force Video is a Salesforce Lightning App to practice with Salesforce configuration, APEX code, and Lightning Web Components. 

There is a demo user available to try the app:
- Login URL: https://darioabuincom2-dev-ed.develop.lightning.force.com/
- User: external@forcevideo.com
- Password: 12345678A

![FV](https://github.com/abuindario/ForceVideo/assets/92298516/ff280110-092b-4f99-801d-0dcecf07848c)

- Account, Avatar, Content, Season, and Episode custom objects with their own Lightning Record Page and Compact Layout.
- Series and Movies record types. 
## Home
- Available in the AppLauncher.
- Force Video icon and colors are displayed.
- Customized Home Page: see all your active content at once.
  - Click on the desired content to access to its record page.
- Custom Tabs: Home, Accounts, Avatars and Contents.
- Accounts are also accessible from the home page.
  
![home_AppLauncher](https://github.com/abuindario/ForceVideo/assets/92298516/b634a0b4-b230-4daa-8e3e-8fdc6cff636b)

## Accounts
- Account record page with some basic information.
  - There are some validation rules:
    - NIF format must be eight numbers plus a character.
    - Email format must end in '.com' or '.es'.
    - Subscription start date can't be earlier than the account created date.
- Renewal subscription manual flow.
- Renewal subscription automatic flow:
  - If the Automatic Renewal checkbox is checked, when the subscription start date is expired, account will be automatically updated.
  - The user will be notified by email.
- Choose between Movies, Series or a Total subscritpion - the available content will be affected.
- Avatar's related list.
- If a new Account is created, a new avatar (Primary Avatar) will be created.
- There can not exist more than 4 avatars per Account.

![accountRecordPage](https://github.com/abuindario/ForceVideo/assets/92298516/2c180759-2fa7-495d-9877-d74b12582379)

- See the available content from the content tab.

![account_seriesSubscriptor_content](https://github.com/abuindario/ForceVideo/assets/92298516/2fb1f4ad-5502-498b-b874-5647c021c90a)

## Avatars
- Avatar record page with some basic information.
  - There are some validation rules:
    - Parental control is not available if the avatar selected is the Primary Avatar.
    - There is only one primary avatar per account.
    - It is not possible to delete a Primary Avatar.
    - It is not possible to uncheck the primary avatar checkbox. If you try, an alert will be displayed.
    - If an avatar is selected as Primary Avatar, the previous Primary Avatar will be removed as the Primary Avatar.

![avatar_moviesSubscriptor](https://github.com/abuindario/ForceVideo/assets/92298516/a799d17d-08e6-4350-b8c6-83d51bc5350d)

## Contents
- A list of all active, inactive, and discontinued content.
- Content record page with some basic information.
- Content records come from OMDb API.
- Content record type must start with 'tt'.

![content_barbieRecordPage](https://github.com/abuindario/ForceVideo/assets/92298516/a878a329-5f8f-48b4-9049-08e5e532ef91)

## Seasons and Episodes
- These tabs are not visible by default.
- It is possible to access to a season record page or to a episode record page from their Content Record Page.
- Season record page contain the list of episodes.
- Episode record page contain some basic information of the episodes.
- Episode record type must start with 'tt'.

![content_breakingBadRecordPage](https://github.com/abuindario/ForceVideo/assets/92298516/a9c54fde-6d2e-41de-8272-f21677fda02e)

## APEX code
- Account and Avatar triggers.
- Classes to call the OMDb API, wrapper classes, and upserting DML operations.

![APIcallVSC](https://github.com/abuindario/ForceVideo/assets/92298516/d8e6c17f-5a93-492d-86c9-c86ef2405f63)

## LWC code
- Content Gallery LWC, Content Tile LWC, Content Gallery Home Page LWC.
- Display the content list in the Home Page and in the Account Record Page.
- Open the content record page by clicking on its details.

![contentGalleryVSC](https://github.com/abuindario/ForceVideo/assets/92298516/1e0f4c7c-eacb-45fb-b1b8-1c477b002297)

##
