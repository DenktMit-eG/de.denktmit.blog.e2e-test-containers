package de.denktmit.tests.samples.config;

import com.codeborne.selenide.Configuration;
import com.codeborne.selenide.Selenide;
import com.thoughtworks.gauge.AfterSuite;
import com.thoughtworks.gauge.BeforeSuite;
import com.thoughtworks.gauge.Logger;
import com.thoughtworks.gauge.datastore.SuiteDataStore;
import org.openqa.selenium.firefox.FirefoxOptions;
public class AppLauncher {

  @BeforeSuite
  public void BeforeSuite() {
    prepareSuiteStore();
    prepareSelenide();
  }

  private void prepareSuiteStore() {
    for (ConfigParam param : ConfigParam.values()) {
      SuiteDataStore.put(param, load(param.name()));
    }
  }

  private String load(String key) {
    String value = System.getenv(key);
    Logger.info(key + " resolves to: " + value);
    return value;
  }

  private void prepareSelenide() {
    System.setProperty("webdriver.firefox.logfile", "/dev/null");
    Configuration.browser = "firefox";
    FirefoxOptions options = new FirefoxOptions();
    // Use system-installed Firefox instead of Selenium Manager's auto-download
    String firefoxBinary = System.getenv("FIREFOX_BINARY");
    if (firefoxBinary != null) {
      options.setBinary(firefoxBinary);
    }
    if ("true".equals(load(ConfigParam.HEADLESS_BROWSER.name()))) {
      options.addArguments("-headless");
    }
    Configuration.browserCapabilities.merge(options);
    String timeoutStr = System.getenv("SELENIDE_TIMEOUT");
    Configuration.timeout = timeoutStr != null ? Long.parseLong(timeoutStr) : 5000;
  }

  @AfterSuite
  public void AfterSuite() {
    Selenide.closeWebDriver();
  }

}
