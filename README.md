# Banking App case

A simple banking app. 

## Features

### Create a new user:
 
```
User.create(first_name: "Konstantinos", last_name: "Kalpakloglou", email: "kkalpakloglou@yahoo.com", password: "********")
```

### Create a new account:
 
```
Account.create(user: my-user)
```

### Credit an account:

```
Transaction.create(transaction_type: :credit, amount: 100, account: random-account)
```

### Transactions History:

```
http://localhost:3000/accounts/:id/transactions
```

### Transfer Money:

```
http://localhost:3000/money_transfers
```
