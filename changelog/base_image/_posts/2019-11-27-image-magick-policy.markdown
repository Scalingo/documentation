---
modified_at: 2019-11-27 12:30:00
title: '[ImageMagick] Less Restriction'
---

We updated `scalingo-14` and `scalingo-18` stacks to remove a restriction we
used to impose on the use of ImageMagick. There is no more restriction in the
`policy.xml` file for PDF generation.

For instance, the following command use to fail and is not executable on
Scalingo:

```
convert file.png -units PixelsPerInch -density 200 -resize "600x800" file.pdf
```
