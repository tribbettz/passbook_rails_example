![Passbook](http://cl.ly/JPjc/title_passbook.png)

# Passbook on Rails Example

[Passbook](http://www.apple.com/ios/whats-new/#passbook) is an iOS 6 feature that manages boarding passes, movie tickets, retail coupons, & loyalty cards. Using the [PassKit API](https://developer.apple.com/library/prerelease/ios/#documentation/UserExperience/Reference/PassKit_Framework/_index.html), developers can register web services to automatically update content on the pass, such as gate changes on a boarding pass, or adding credit to a loyalty card.

Apple [provides a specification](https://developer.apple.com/library/prerelease/ios/#documentation/PassKit/Reference/PassKit_WebService/WebService.html) for a REST-style web service protocol to communicate with Passbook, with endpoints to get the latest version of a pass, register / unregister devices to receive push notifications for a pass, and query for passes registered for a device.

This project is an example implementation of this web service specification in Rails, and will serve the basis for a more comprehensive Rails generator in the near future.

## Getting Started

```
$ git clone https://github.com/mattt/passbook_rails_example.git
$ cd passbook_rails_example
$ bundle
$ rake db:create db:migrate db:seed
$ rails s
```

## Points of Interest

Rails generates a _ton_ of boilerplate. For your convenience, here's a list of the files that actually demonstrate the Passbook functionality:

- `app/controllers/passbook/*.rb` 
- `app/models/passbook/*.rb`
- `db/migrate/*.rb`
- `db/seeds.rb`

## Deployment

[Heroku](http://www.heroku.com) is the easiest way to get your app up and running. For full instructions on how to get started, check out ["Getting Started with Rails 3.x on Heroku"](https://devcenter.heroku.com/articles/rails3).

Once you've installed the [Heroku Toolbelt](https://toolbelt.heroku.com), and have a Heroku account, enter the following commands from the project directory:

```
$ heroku create
$ git push heroku master
$ heroku run rake db:migrate
```

Take the URL from your newly-created Heroku app, and specify that as the webservice URL for your Passbook bundle.

To send push notifications about changes in a user's pass, check out [houston](https://github.com/mattt/houston).

---

## Specification

What follows is a summary of the specification. The complete specification can be found in the [Passbook Web Service Reference](https://developer.apple.com/library/prerelease/ios/#documentation/PassKit/Reference/PassKit_WebService/WebService.html).

### Getting the Latest Version of a Pass

```
GET http://example.com/v1/passes/:passTypeIdentifier/:serialNumber
```

- **passTypeIdentifier** The pass’s type, as specified in the pass.
- **serialNumber** The unique pass identifier, as specified in the pass.

**Response**

- If request is authorized, return HTTP status 200 with a payload of the pass data.
- If the request is not authorized, return HTTP status 401.
- Otherwise, return the appropriate standard HTTP status.

### Getting the Serial Numbers for Passes Associated with a Device

```
GET http://example.com/v1/devices/:deviceLibraryIdentifier/registrations/:passTypeIdentifier[?passesUpdatedSince=tag]
```

- **deviceLibraryIdentifier** A unique identifier that is used to identify and authenticate the device.
- **passTypeIdentifier** The pass’s type, as specified in the pass.
- **serialNumber** The unique pass identifier, as specified in the pass.
- **passesUpdatedSince** _Optional_ A tag from a previous request. 

**Response**

If the `passesUpdatedSince` parameter is present, return only the passes that have been updated since the time indicated by tag. Otherwise, return all passes.

- If there are matching passes, return HTTP status 200 with a JSON dictionary with the following keys and values:
    - **lastUpdated** _(string)_ The current modification tag.
    - **serialNumbers** _(array of strings)_ The serial numbers of the matching passes.
- If there are no matching passes, return HTTP status 204.
- Otherwise, return the appropriate standard HTTP status.

### Registering a Device to Receive Push Notifications for a Pass

```
POST http://example.com/v1/devices/:deviceLibraryIdentifier/registrations/:passTypeIdentifier/:serialNumber
```

- **deviceLibraryIdentifier** A unique identifier that is used to identify and authenticate the device.
- **passTypeIdentifier** The pass’s type, as specified in the pass.
- **serialNumber** The unique pass identifier, as specified in the pass.

The POST payload is a JSON dictionary, containing a single key and value:

- **pushToken** The push token that the server can use to send push notifications to this device.

**Response**

- If the serial number is already registered for this device, return HTTP status 200.
- If registration succeeds, return HTTP status 201.
- If the request is not authorized, return HTTP status 401.
- Otherwise, return the appropriate standard HTTP status.

### Unregistering a Device

```
DELETE http://example.com/v1/devices/:deviceLibraryIdentifier/registrations/:passTypeIdentifier/:serialNumber
```

- **deviceLibraryIdentifier** A unique identifier that is used to identify and authenticate the device.
- **passTypeIdentifier** The pass’s type, as specified in the pass.
- **serialNumber** The unique pass identifier, as specified in the pass.

**Response**

- If disassociation succeeds, return HTTP status 200.
- If the request is not authorized, return HTTP status 401.
- Otherwise, return the appropriate standard HTTP status.

---

## Contact

Mattt Thompson

- http://github.com/mattt
- http://twitter.com/mattt
- m@mattt.me

## License

passbook_rails_example is available under the MIT license. See the LICENSE file for more info.

