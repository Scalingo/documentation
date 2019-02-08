This process requires you to edit the `composer.json` file of your project.
Edit the file the following way:

```json
{
  ...
  "extra": {
    "paas": {
      "nginx-includes": ["{{nginx-include}}"]
    }
  }
}
```

If you are not using composer, create a `composer.json` file with the previous
content, and also create a file `composer.lock` containing an empty JSON
dictionary `{}`.

{% note %}
Tip: You can find more information about extra configuration in [the PHP
support page]({% post_url languages/php/2000-01-01-start %}).
{% endnote %}
