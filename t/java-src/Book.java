package bookletski;
    
import java.util.Set;

public class Book {
    Integer id;
    String  title;
    String  ISBN;
    String  authors;
    String  description;
    String  category;
    String  difficulty;
    Set     categories;

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getId() {
        return id;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }

    public String getTitle() {
        return title;
    }

    public void setISBN(String ISBN) {
        this.ISBN = ISBN;
    }

    public String getISBN() {
        return ISBN;
    }

    public void setAuthors(String authors) {
        this.authors = authors;
    }

    public String getAuthors() {
        return authors;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getCategory() {
        return category;
    }

    public void setDifficulty(String difficulty) {
        this.difficulty = difficulty;
    }

    public String getDifficulty() {
        return difficulty;
    }

    public void setCategories(Set categories) {
        this.categories = categories;
    }

    public Set getCategories() {
        return categories;
    }

    public int hashCode() {
        return id.intValue();
    }
}
