package com.kdf;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.github.sangkeon.opa.wasm.Bundle;
import io.github.sangkeon.opa.wasm.BundleUtil;
import io.github.sangkeon.opa.wasm.OPAModule;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Main {
  private static Logger logger = LoggerFactory.getLogger(Main.class);
  private ObjectMapper objectMapper = new ObjectMapper();

  protected String readFile(String filePath) throws IOException {
    return Files.readString(Path.of(filePath));
  }

  private void run() {

    try {
      String input = this.readFile("../config/opa_input.json");
      Bundle bundle = BundleUtil.extractBundle("../config/bundle.tar.gz");

      try (OPAModule om = new OPAModule(bundle); ) {

        String valueString = om.evaluate(input, "example/label_to_use");

        JsonNode evaluation = objectMapper.readTree(valueString);
        logger.info("evaluation result: {}", evaluation);

        JsonNode result = evaluation.get(0).get("result");
        logger.info("rule: {}, label: {}", result.get("rule"), result.get("label"));
      }
    } catch (Exception e) {
      logger.warn("failure", e);
    }
  }

  public static void main(String[] args) {
    Main main = new Main();
    main.run();
  }
}
