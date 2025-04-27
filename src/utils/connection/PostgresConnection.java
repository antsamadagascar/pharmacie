package utils.connection;

import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

@SuppressWarnings("UseSpecificCatch")
public class PostgresConnection {
    private static String dbUrl;
    private static String dbUser;
    private static String dbPassword;

    static {
        String configPath = PostgresConnection.class.getClassLoader().getResource("config/config.properties").getFile();

        try {
            configPath = URLDecoder.decode(configPath, "UTF-8");
        } catch (Exception e) {
            System.err.println("Erreur de décodage de l'URL : " + e.getMessage());
        }
        System.out.println("Chargement du fichier de configuration depuis : " + configPath);

        try (FileInputStream input = new FileInputStream(configPath)) {
            Properties properties = new Properties();
            properties.load(input);
            System.out.println(properties);
            dbUrl = properties.getProperty("db.url");
            dbUser = properties.getProperty("db.user");
            dbPassword = properties.getProperty("db.password");

            if (dbUrl == null || dbUser == null || dbPassword == null) {
                throw new IOException("Propriétés manquantes dans le fichier de configuration.");
            }

            System.out.println("Configuration chargée :");
            System.out.println("URL : " + dbUrl);
            System.out.println("Utilisateur : " + dbUser);
        } catch (IOException e) {
            System.err.println("Erreur lors du chargement de la configuration : " + e.getMessage());
        }
    }

    public static Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("org.postgresql.Driver");

            connection = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            System.out.println("Connexion établie avec succès !");
        } catch (ClassNotFoundException e) {
            System.err.println("Erreur lors du chargement du pilote JDBC : " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("Erreur lors de la connexion à la base de données : " + e.getMessage());
        }

        return connection;
    }

    public static void main(String[] args) {
        Connection connection = getConnection();
        if (connection != null) {
            try {
                connection.close();
                System.out.println("Connexion fermée avec succès !");
            } catch (SQLException e) {
                System.err.println("Erreur lors de la fermeture de la connexion : " + e.getMessage());
            }
        } else {
            System.out.println("La connexion à la base de données a échoué.");
        }
    }
}
