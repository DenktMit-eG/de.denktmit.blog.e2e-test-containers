Web Search samples
==================

Do a predefined web search
--------------------------
tags: search, smoke

* Given I visit DuckDuckGo searchpage
* When I search for term "github"
* Then I will see a search result with headline "Where the world builds software"

Do a custom web search
----------------------
tags: search, custom

* Given I visit DuckDuckGo searchpage
* When I search for custom term "${SEARCH_TERM}"
* Then I will see a custom search result with headline "${EXPECTED_RESULT_CONTAINS}"