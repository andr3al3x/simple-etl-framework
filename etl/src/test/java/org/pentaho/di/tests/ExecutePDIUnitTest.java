package org.pentaho.di.tests;

import org.junit.Test;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

import static org.junit.Assert.*;

/**
 * Pentaho Junit Unit Test Executor
 *
 * This test class executes PDI Transformations or jobs that end in _test and exist inside the
 * repository/tests/unit path
 */

public class ExecutePDIUnitTest {
    private static String UNIT_TEST_JOB = "tests/test_executor.ktr";
    private static String EXEC_BIN_PATH = "bin/base";
    private static String PDI_TRANS_SCRIPT = "pan.sh";
    private static String PDI_JOB_SCRIPT = "kitchen.sh";

        @Test
    public void runPDIUnitTest() {
        int returnCode = 0;
        String result = null;
        File baseBinFolder = new File(EXEC_BIN_PATH);
        String executable = PDI_TRANS_SCRIPT;
        String testName=UNIT_TEST_JOB;

        // check if this is a job or transformation to call the correct script
        if(testName.endsWith(".kjb")) {
            executable = PDI_JOB_SCRIPT;
        }

        // proxy pan and kitchen scripts expect to have the path inside the repo provided only


        ProcessBuilder script = new ProcessBuilder(baseBinFolder.getAbsolutePath() + "/" + executable, testName)
                .redirectErrorStream(true);

        script.directory(baseBinFolder);

        try {
            Process p = script.start();

            //capture the output to be used in case of failure
            BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream()));
            StringBuilder builder = new StringBuilder();
            String line;
            while ( (line = br.readLine()) != null) {
                builder.append(line);
                builder.append(System.getProperty("line.separator"));
            }

            result = builder.toString();

            returnCode = p.waitFor();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        if(returnCode != 0) {
            fail(result);
        }
    }
}
