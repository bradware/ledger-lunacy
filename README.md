# About this project

 - You should spend about three hours on this.
 - Expect to spend 1.5-2 hours on mission 1.
 - Most parts of missions 2 and 3 do not require coding. Instead, write your answers the text files in the `answers` directory.
 - Be prepared to present your solutions and discuss them when you arrive at AngelList's office.

# Ledger Lunacy

Suppose you are writing a UI for a bank account that investors use to invest in startups. You only have access to an API
created by the underlying bank.

The problem is that this API is unreliable. The ledger entries may not be in the order in which they actually happened,
they may have duplicate entries, or they may not have all the entries for an investor.

Regardless, your mission is to display the most accurate possible ledger to users.

## Mission 1: Display historical transactions

This mission has a few parts:

### 1. Given a ledger, display it in a logical order.

Ledgers are defined as JSON files containing a single array. Each object in the array represents one transaction.

Transactions have activity ids, datetimes, amounts, and balances. The balance represents the balance in the investor's
account *after* the transaction has been applied.

Example:

```
[
    {
        "activity_id": "1",
        "date": "2014-10-01T01:00:29+00:00",
        "type": "DEPOSIT",
        "method": "ACH",
        "amount": 1003.75,
        "balance": 1003.75,
        "requester": {
            "type": "INVESTMENT"
        },
        "source": {
            "type": "EXTERNAL",
            "id": 18238147,
            "description": "Chase ** 9867"
        },
        "destination": {
            "type": "INVESTOR",
            "id": 76510190788,
            "description": "Michael Daugherty"
        }
    }
]
```

This ledger has one entry, a deposit. Before this transaction occurred, the investor's balance was $0. After $1003.75
was deposited, the investor's balance was $1003.75.

To view a ledger, start your Sinatra server (instructions below) and navigate to

[http://localhost:4567/simple_ledger]

This will load and display the ledger file at data/simple_ledger.json. Change the URL to view the other ledger files.

`duplicate_ledger` is a ledger that contains two entries with the same activity_id. Modify the application code to
filter out one of them and display the resulting ledger.

`complicated_ledger` has more kinds of errors. Figure out how to transform this into an understandable ledger for our
investors and modify `server.rb` and `ledger.haml` to do so.

### 2. Describe transactions in a human-readable manner.

I've included a simplified screenshot of how we display ledgers on AngelList. Notice that each transaction has a logical
description like "Deposit from Chase Bank **0978 for your investment in Uber".

Come up with your own logical descriptions for these transactions and display them in the "Description" column of the
transaction table.

![AngelList Investing Account](/angellist_screenshot.png)

### 3. CSS/Style

Write a stylesheet for your application. You can make it look like the AngelList screenshot or just use that as
inspiration.

## Mission 2: UX for depositing & withdrawing funds

A bank account is more than just a list of transactions. To be
complete, users should be able to deposit and withdraw funds.

You can draw some wireframes or do an HTML mockup for this. Some questions to get you started are below.

- Where do these flows live?
- How does the user discover them?
- What information should we require? How can we simplify?
- Are there any security concerns?

We will discuss your proposal when you come in-person to the
AngelList office.

## Mission 3: Customer support

### 1. Debugging

**Important: Do not read part 2 until you finish this question**

We've now launched your bank account UI and you're on customer
support. You receive the following email:

> Hello,
>
> I wired money for Startup X, and it doesn't show in my account.
>
> Please confirm.
>
> Dr. V. Horrible

How would you start investigating this user's issue? Who would you
talk to and what questions would you ask? What are some hypotheses
and what would falsify them?

Note, we're not looking for a solution for Dr. Horrible's missing
wire here; we're interested to see how you would begin diagnosing the
issue.

### 2. Answering the user

Now, let's assume that the wire was $10k and had been received. It
was appearing in the Bank's API, but our code had a bug that was
filtering it out as we tried to clean the transaction history. This
went on for a week, and we had assumed he wasn't wiring, so we closed
the deal without him.

Write an email to Dr. Horrible to explain the situation. What else
can we do to help him out?

# Setup

Ledger Lunacy is implemented in Ruby and uses [Sinatra](www.sinatrarb.com) to run a lightweight web server.

If you have [RVM (Ruby Version Manager)](http://rvm.io/) installed, it's very simple to get started:

```
$ cd /path/to/ledger_lunacy/
# You will get a message from RVM about installing Ruby and setting up a gemset for this project
$ gem install bundler
$ bundle install
$ rerun 'ruby server.rb' # Using rerun will reload the application whenever you make a change.
```

If you don't have RVM installed, I highly suggest installing it so that you can run multiple versions of ruby and
separate your dependencies per project.

However, it is not strictly necessary. As long as you have Ruby installed, you should be able to run:

```
$ cd /path/to/ledger_lunacy/
$ gem install bundler
$ bundle install
$ rerun 'ruby server.rb' # Using rerun will reload the application whenever you make a change.
```

If you run into any problems, please reach out.