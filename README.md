# Bloom & Wild Backend Test

Hello and welcome to the Bloom & Wild coding exercise!

Please read through the introduction below and complete the Tasks.

When you have finished please raise a PR and email ella@bloomandwild.com. If you have any questions along the way feel free to drop her an email too.

## Introduction

In this exercise you will be building a backend system to process customer orders and provide data to frontend clients via an API.
We have provided a skeleton rails app to get you started, please familiarise yourself with the existing application structure before getting started.

Here is a brief overview of the existing models in the application:
- **Bouquet**: This is a representation of a Bouquet of flowers that is available for ordering / delivery.
- **Order**: This is a simple representation of a customer order. The customer can choose the date of their first delivery as `first_delivery_date`.
- **OrderType**: Customers can choose either a "Single delivery" or a "3 month bundle". In the future, we may expand this to other order types.
- **Delivery**: An individual delivery to a recipient. An Order can have one or more Deliveries.
- **ShippingOption**: Customers can choose different options for shipping, which may be free or charged.

For the purposes of this exercise, we are not concerned with delivery addresses.

## What We'll be looking for:

* A clean and simple solution
* Done in a conventional way
* With solid test coverage

You are welcome to change any part of the existing skeleton app if your solution requires it.

## Getting started

Once you've got this skeleton rails app up and running visit http://localhost:3000 and use the simple UI to create an order. Remember to seed the database first.

## Tasks

1. Add a rake task called "shipping".
   * When this task runs it should take a date
    as an argument and create a "Delivery" object for all the orders going out
    on that date which have a status of "billed".
   * Note that orders for the "3 month bundle" type should have a total of three deliveries, 28 days apart from each other. This task should only create the delivery that is to be shipped on that date.
   * It should set the status of an order to "complete" when all the deliveries for that order have been created.

2. The "Free shipping" shipping option shouldn't be available to book over bank holidays.
   * Please update the rake task
    to move any deliveries with bank holiday date to the next non-bank holiday date. For example deliveries for 1st January 2020 should be moved to the 2nd January 2020.
   * List of bank holidays - https://www.gov.uk/bank-holidays / https://www.gov.uk/bank-holidays.json.

3. Expose delivery information (recipient name, bouquet name, order ID, shipping option name and price) through a public API endpoint for the mobile apps team to use. While you should consider how the API endpoint would be used by a mobile app, please don't implement any authentication in the API.
   * You are welcome to choose the format / build it yourself or use any gem to solve the problem.


## Discussion

How might you improve the architecture of the code? Specifically what might happen if the application were to die mid way through rake task and what will happen as complexity increases.

### Clarification
I would ask for clarification on the '3 month bundle' deliveries. The task says "3 month bundle" have 3 deliveries but that I should only create the delivery 'on that date', singular. So I've only created the first delivery.


### Decisions
I have never implemented an API call that only needs to be called once every few years like the bank holidays endpoint. I opted for saving the json locally and raising an ArgumentError if the bank holidays are out of date. I considerd automating this process but, considering the very infrequent calls, it was better to leave this manual.

The rake task is idempotent - even if the application were to die half way through. One potential problem would have occurred if the application died the moment after a delivery was created, but before the order was updated to 'completed'. The order would be incorrectly labelled. The transaction block - assuming correct DB configuration - mitigates this problem.


### Increasing complexity
As performance needs increases, it would be helpful to make the ActiveRecord queries more efficient: For example, condense all INSERT queries into one query.

In the AR query in 'Order.create_deliveries_on', I currently check for orders that do not have deliveries: it may be necessary to change this to orders that do not have deliveries on the date supplied in the rake task parameter, which is slightly more accurate.


### Final Comments
I didn't want to leverage the Selectable module because the '#to_select_with_price' fires a deprecation warning about a 'Dangerous query method'.


