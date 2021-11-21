package de.denktmit.blog.e2e_test_containers;

import com.thoughtworks.gauge.Step;

public class RosePoemSteps {

  @Step("A rose is a rose is a <answer>")
  public void poemSuccessful(String answer) {
    if (!"rose".equals(answer)) {
      throw new AssertionError(String.format("The answer '%s' is wrong", answer));
    }
  }

}
