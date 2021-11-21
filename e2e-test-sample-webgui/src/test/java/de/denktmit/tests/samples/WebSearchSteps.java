package de.denktmit.tests.samples;

import com.codeborne.selenide.Condition;
import com.thoughtworks.gauge.Step;
import de.denktmit.tests.samples.config.SuiteVariableResolver;
import org.openqa.selenium.By;

import static com.codeborne.selenide.Selectors.byName;
import static com.codeborne.selenide.Selenide.$;
import static com.codeborne.selenide.Selenide.open;

public class WebSearchSteps {

  @Step("Given I visit DuckDuckGo searchpage")
  public void visitDuckDuckGo() {
    open("https://duckduckgo.com/");
  }

  @Step("When I search for term <term>")
  public void searchForTerm(String term) {
    $(byName("q")).setValue(term).pressEnter();
  }

  @Step("Then I will see a search result with headline <headline>")
  public void verifyResultsContain(String headline) {
    $(By.id("links")).shouldHave(Condition.text(headline));
  }

  @Step("When I search for custom term <term>")
  public void searchForCustomTerm(String term) {
    term = SuiteVariableResolver.resolve(term);
    $(byName("q")).setValue(term).pressEnter();
  }

  @Step("Then I will see a custom search result with headline <headline>")
  public void verifyCustomResultsContain(String headline) {
    headline = SuiteVariableResolver.resolve(headline);
    $(By.id("links")).shouldHave(Condition.text(headline));
  }

}
