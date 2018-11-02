---
title:	'Vertical scalingo parameter'
---

Details at [http://developers.scalingo.com#changelog](http://developers.scalingo.com#changelog)

New parameter `size` for containers vertical scaling

Before:
```
{
  "containers": [
    {
      "id": "52fd2457356330032b020000",
      "name": "web",
      "amount": 2
    }, {
      "id": "52fd235735633003210a0001",
      "name": "worker",
      "amount": 1
    }
  ]
}
```

After:

```
{
  "containers": [
    {
      "id": "52fd2457356330032b020000",
      "name": "web",
      "amount": 2,
      "size": "L"
    }, {
      "id": "52fd235735633003210a0001",
      "name": "worker",
      "amount": 1,
      "size": "M",
    }
  ]
}
```
