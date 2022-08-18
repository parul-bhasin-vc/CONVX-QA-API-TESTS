import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;

class TestRunner {

    static String env;

    @BeforeAll
    public static void initialize(){
        env = System.getProperty("karate.env");

    }

    @Test
    void testParallel() {
        Results results = Runner.path("classpath:")
                //.outputCucumberJson(true)
                .tags("~@Ignore").parallel(20);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }

    @AfterAll
    public static void tearDown()
    {

    }

}
