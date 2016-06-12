# SOCRATA LAYAR ADAPTER

A simple Ruby framework to allow geocoded datasets from a Socrata data portal to be published as an augmented reality overlay in the Layar mobile application.

## Overview

[Layar](https://www.layar.com/) is a freely available mobile application that provides a variety of ways for developers to [build augmented reality experiences](https://www.layar.com/features/developers/).

The most basic feature is the ability to create "Geo Layers" that expose points of interest as an augmented reality overlay that can be views from the phone.

Layar does not store the data shown in the overlay. In order to integrate it with the app you must [implement an API](https://www.layar.com/documentation/browser/api/) that allows the application to request the data it requires. The API endpoint is then registered in the developer console and then published as a layer for anyone to access.

This framework provides a simple adapter that bridges between the Layar API and the Socrata dataset API. It can easily be deployed to Heroku to provide a quick way to expose georeferenced open data as an augmented reality layer. 

Some basic configuration options are provided to customise how the data is presented in the Layar application. This allows for rapid deployment and prototyping. 

The code can be extended to create a more tailored experience.
 
## Running the code

The code is built with Ruby 2.2.0. It uses the Sinatra framework to implement the web API. Install ruby, rubygems and bundle then install the other dependencies with:

`bundle install`

Run the application locally with:

`bundle exec rackup`

You can then visit `http://localhost:9292` to view the welcome page.

Or `bundle exec shotgun` and use `http://localhost:9393` to have the app auto-reload in development.

## Dataset Configuration

In order to query the dataset and then generate a Layar API response the framework needs to know a few things about the dataset.

Sensible defaults have been chosen to try to reduce the need for any configuration.

| Config | Description | Default
| --- | --- | --- |
| `layerName` | Name of the Layar | None
| `id` | Field containing a unique id for the POI | Generates a unique integer
| `field` | Name of the location field. Must have a data type of `location` in Socrata | `location`
| `title` | Field containing the title of the POI | `title`
| `description` | Field containing a description of the POI | `description`
| `imageURL` | Field containing an image URL | None

These parameters are all provided as matrix URL parameters.

E.g the following relies on defaults so will query the `location` field of the `uau9-ufy3` dataset:

```
/layar/uau9-ufy3?lat=51.382436&lon=-2.359143&radius=100
```

Whereas the following will use the `coords` field, whilst also specifying the id and title fields

```
/layar/2nfa-a2s6;id=id;title=customtitle?lat=51.382436&lon=-2.359143&radius=100
```

## Creating the Layar layers

You will first need to [create a developer account on Layar](https://www.layar.com/accounts/login/?next=/account/developer-signup/%3Fnext%3Dmy-layers).

Once registered you can go to [My Layers](https://www.layar.com/my-layers/) and choose add new Geo Layar giving it a name.

You can use the provided forms to further configure the Layar:

* Ensure the type is "Geo Layer"
* Unless your dataset has global coverage, specify the country in which it should be used
* Make a note of the layar name which you should use in your `layerName` config.

The base URL of your layar will be:

```
<location-of-application/layar/<socrata-dataset-id>
```

The `layerName` configuration seems optional, but probably best to include it. So for example for the test deployment at
`http://socrata-layar.herokuapp.com` in order to create a layer for the Bath Public Art Catalogue (`uau9-ufy3`) we would 
configure something like this for the Layar API URL:

```
http://socrata-layar.herokuapp.com/layar/uau9-ufy3;layerName=bathpublicark05
```

*Note*: the framework has a simple web based interface to help you build these URLs. Here's [an example](http://socrata-layar.herokuapp.com/dataset/tgc7-2htd).

There are a number of other configuration items in Layar which can help tailor the display and behaviour of your layer.

## Testing your Layar

* Install the Layar mobile application
* Sign in using your developer account details
* Look at the test layers and your new layer should be visible

Be sure to publish the layer once completed so other people can see it.

## Deploy to Heroku

If you have a Heroku account then you can deploy this framework for free. Just click the button. When you're prompted, give the application a 
name and the domain for the Socrata catalog you'll be building layers against. It will default to the Bath: Hacked datastore if you just want 
to test it out.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## Example Deployment

There's a sample app running on Heroku.

* [Homepage](http://socrata-layar.herokuapp.com/)
* [Layar Configuraton](http://socrata-layar.herokuapp.com/dataset/tgc7-2htd). Change the id in the URL to configure a different dataset.
* [Points of interest from the Bath Public Art catalogue, within 100m of the Guild Hall](http://socrata-layar.herokuapp.com/layar/uau9-ufy3?lat=51.382436&lon=-2.359143&radius=100)
* Example of a published layer using this framework: [Bath Food Hygiene](https://www.layar.com/layers/bathfoodhygi9ru4). However its not really useful unless you're in or around Bath!




