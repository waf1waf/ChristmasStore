package cc.nhf;

import com.mashape.unirest.http.HttpResponse;
import com.mashape.unirest.http.JsonNode;
import com.mashape.unirest.http.Unirest;
import com.mashape.unirest.http.exceptions.UnirestException;
import org.apache.log4j.Logger;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

// In order for this to work, please create a file called mail_properties.txt with two lines:
// - a URL string
// - an API key string
//
// We can't check these into GitHub, so add mail.properties.txt to .gitignore

public class MailREST implements Mail {
    private final Logger logger = Logger.getLogger(this.getClass());
    private static String api;
    private static String url;
    {
        List<String> lines = null;
        try {
            lines = Files.readAllLines(Paths.get("/mail_properties.txt"), StandardCharsets.UTF_8);
            url = lines.get(0);
            logger.info("url: " + url);
            api = lines.get(1);
            logger.info("api: " + api);
        } catch (IOException e) {
            logger.error("Could not read mail_properties.txt: " + e.getLocalizedMessage());
        }
    }
    public synchronized boolean sendMail(String host, String[] to, String[] cc, String[] bcc, String subject, String text) {
        try {
            HttpResponse<JsonNode> request = Unirest.post(url)
                    .basicAuth("api", api)
                    .queryString("from", "The Christmas Store <csadmin@nhf.cc>")
                    .queryString("to", to[0])
                    .queryString("subject", "Christmas Store Volunteer Shifts")
                    .queryString("text", text)
                    .asJson();
        } catch (UnirestException e) {
            logger.error("Failed to send email to " + to[0] + ".  Reason: " + e.getLocalizedMessage());
            return false;
        }
        return true;
    }
}
