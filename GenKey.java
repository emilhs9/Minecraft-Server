import java.security.*;
import java.security.spec.*;
import java.util.Base64;
import java.io.*;

public class GenKey {
    public static void main(String[] args) throws Exception {
        KeyPairGenerator keyGen = KeyPairGenerator.getInstance("RSA");
        keyGen.initialize(2048);
        KeyPair pair = keyGen.generateKeyPair();
        
        // Write ONLY private key in PKCS#8 format (what Floodgate expects)
        String privKey = Base64.getMimeEncoder().encodeToString(pair.getPrivate().getEncoded());
        
        StringBuilder sb = new StringBuilder();
        sb.append("-----BEGIN PRIVATE KEY-----\n");
        sb.append(privKey);
        sb.append("\n-----END PRIVATE KEY-----\n");
        
        PrintWriter out = new PrintWriter(new FileWriter(args[0]));
        out.print(sb.toString());
        out.close();
        
        System.out.println("OK Private key size: " + pair.getPrivate().getEncoded().length);
    }
}