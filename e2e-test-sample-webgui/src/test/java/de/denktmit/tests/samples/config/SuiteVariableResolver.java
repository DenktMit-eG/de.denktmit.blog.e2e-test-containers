package de.denktmit.tests.samples.config;


import com.thoughtworks.gauge.datastore.SuiteDataStore;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public final class SuiteVariableResolver {

  private static final Pattern VARIABLE_PATTERN = Pattern.compile("\\$\\{[^}]+}");

  public static String resolve(String input) {
    Matcher m = VARIABLE_PATTERN.matcher(input);
    StringBuilder sb = new StringBuilder();
    while (m.find()) {
      String keyName = m.group().substring(2, m.group().length() - 1);
      String value;
      try {
        ConfigParam configParam = ConfigParam.valueOf(keyName);
        value = (String) SuiteDataStore.get(configParam);
      } catch (IllegalArgumentException e) {
        value = m.group();
      }
      m.appendReplacement(sb, Matcher.quoteReplacement(value != null ? value : ""));
    }
    m.appendTail(sb);
    return sb.toString();
  }

}
