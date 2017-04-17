# mcrib-locator
A version of mcriblocator.com that can run from the command line

## How to use
Create an address.yaml following this example
```yaml
:street: 123 Main St
:city: Anywhere
:state: California
:country: United States
```

Then run the following:
```
bundle install  (on first run only)
bundle exec ruby ./mcrib-locator.rb
```
