# Zendesk Search App
This app was built using Ruby 2.6.3.

## Usage
1) Clone the repo:
```console
foo@bar:~$ git clone https://github.com/factcondenser/zendesk_search.git
```
2) `cd` into the app's root directory:
```console
foo@bar:~$ cd zendesk_search
```
3) Run the tests to make sure everything's working correctly:
```console
foo@bar:~/zendesk_search$ rake test
```
4) Run the app:
```console
foo@bar:~/zendesk_search$ ruby zendesk_search.rb
```
The usage should be fairly straightforward from there.
## Additional Notes
It's possible to make additional data searchable by this app. `users.json`, `tickets.json`,
and `organizations.json` are the three datafiles searchable by default, but more can be added.
As an example, I've included `movies.json` in the `db` folder under the app's root directory.
To make the data in `movies.json` searchable, make the following changes to `zd_search_policy.rb`:
```diff
module ZdSearchPolicy
  INPUT_MAP = {
    'main' => {
      '1' => 'search',
      '2' => 'list_fields'
    },
    'categories' => {
      '1' => 'users',
      '2' => 'tickets',
-     '3' => 'organizations'
+ .   '3' => 'organizations',
+     '4' => 'movies'
    }
  }.freeze
  
  ...
end
```
The data is `movies.json` was pulled from Wikipedia.
## Known Issues
### Arrays and nested objects
The app is naive in its treatment of arrays and nested objects in the JSON it searches. Searchable fields are only those properties located on the first level of the JSON objects provided by the `db` folder's JSON files. The app assumes that all objects in a given JSON file have the same properties. Searching on a field that has an array as a value is possible, but, as with every other searchable field, only exact matches will turn up results (e.g. an organization for which 'tags' equals '["Fulton", "West", "Rodriguez", "Farley"]' will match a search value of exactly '["Fulton", "West", "Rodriguez", "Farley"]', but will not match 'Fulton' or '["West", "Fulton", "Rodriguez", "Farley"]').
### Coupling between category names and JSON file names
The app expects each category name to match the name of a JSON file in `db` (e.g. 'movies' matches 'db/movies.json'). Not only is this brittle, but due to the way category names currently get displayed, it's also pretty easy to end up with some ugly category options 
(e.g. 'db/pull_requests.json' would need a matching 'pull_requests' category name. In the app, this would get displayed as 'Pull_requests').  
### Odd output format in test fixtures
The test fixtures containing the output to STDOUT from running through various scenarios with the app (`test/fixtures/*_output.txt`) all
list the values of the 'user' inputs (mocked by piping in strings from one of `test/fixtures/*_input.txt`) before everything else. For some reason I haven't figured out yet, that's the way the output for those scenarios consistently looks. For example, running
```console
foo@bar:~/zendesk_search$ cat test/fixtures/quit_input.txt | ruby zendesk_search.rb --environment test
```
outputs
```console
Welcome to Zendesk Search!
Type 'q' or 'quit' to exit at any time

========== SEARCH OPTIONS ==========
1) Search Zendesk
2) View a list of searchable fields

Please enter your choice: quit

Thank you for using Zendesk Search!
```
but running that same line in the test file using backticks
```ruby
`cat test/fixtures/quit_input.txt | ruby zendesk_search.rb --environment test`
```
outputs
```console
Please enter your choice: quit
Welcome to Zendesk Search!
Type 'q' or 'quit' to exit at any time

========== SEARCH OPTIONS ==========
1) Search Zendesk
2) View a list of searchable fields

Thank you for using Zendesk Search!
```
Notice how 'Please enter your choice: quit' appears at the top of the latter output.
## Feedback
I'm always looking for ways to improve, so feel free to [email me](mailto:mark@markcuipan.com). Any feedback is welcome!
