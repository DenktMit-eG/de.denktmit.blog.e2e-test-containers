package de.denktmit.tests.samples.config;

import com.codeborne.selenide.Configuration;
import com.codeborne.selenide.WebDriverRunner;
import com.thoughtworks.gauge.AfterSuite;
import com.thoughtworks.gauge.BeforeSuite;
import com.thoughtworks.gauge.Logger;
import com.thoughtworks.gauge.datastore.SuiteDataStore;
import org.openqa.selenium.firefox.FirefoxDriver;

public class AppLauncher {

  @BeforeSuite
  public void BeforeSuite() {
    System.setProperty("webdriver.chrome.logfile", "/tmp/chromedriver.log");
    System.setProperty("webdriver.chrome.verboseLogging", "true");
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
    System.setProperty(FirefoxDriver.SystemProperty.BROWSER_LOGFILE,"/dev/null");
    Configuration.browser = "firefox";
    Configuration.driverManagerEnabled = true;
    Configuration.headless = "true".equals(load(ConfigParam.HEADLESS_BROWSER.name()));
    Configuration.timeout = 5000;
  }

  @AfterSuite
  public void AfterSuite() {
    WebDriverRunner.closeWebDriver();
  }

}
