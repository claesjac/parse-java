package bookletski;

public class User {
    boolean isLoggedIn = false;
    Integer id;
    String login;
    String password;
    String name;
    String email;

    public void setIsLoggedIn(boolean isLoggedIn) {
        this.isLoggedIn = isLoggedIn;
    }

    public boolean getIsLoggedIn() {
        return isLoggedIn;
    }

    public boolean isLoggedIn() {
        return getIsLoggedIn();
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getId() {
        return id;
    }
    
    public void setLogin(String login) {
        this.login = login;
    }

    public String getLogin() {
        return login;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }

    public String getPassword() {
        return password;
    }
    
    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }

    public String getEmail() {
        return email;
    }
}
