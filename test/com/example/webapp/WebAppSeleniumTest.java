package com.example.webapp;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import static org.junit.jupiter.api.Assertions.*;

/**
 * SeleniumとJUnit 5を使用したWebアプリケーションの統合テスト
 */
public class WebAppSeleniumTest {

    private WebDriver driver;
    private String baseUrl = "http://localhost:8080";

    @BeforeEach
    public void setUp() {
        // ChromeDriverのパスを設定
        System.setProperty("webdriver.chrome.driver", "./chromedriver");

        // ChromeOptionsを設定
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--headless"); // ヘッドレスモード（GUIなし）
        options.addArguments("--no-sandbox");
        options.addArguments("--disable-dev-shm-usage");
        options.addArguments("--disable-gpu");
        options.addArguments("--window-size=1920,1080");

        driver = new ChromeDriver(options);
    }

    @AfterEach
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }

    @Test
    public void testIndexPage() {
        driver.get(baseUrl + "/");

        // ページタイトルを確認
        String pageTitle = driver.getTitle();
        assertEquals("Webアプリテストサンプル", pageTitle);

        // タイトル要素を確認
        WebElement titleElement = driver.findElement(By.id("title"));
        assertTrue(titleElement.getText().contains("Webアプリテストサンプル"));

        // メッセージ要素を確認
        WebElement messageElement = driver.findElement(By.id("message"));
        assertTrue(messageElement.isDisplayed());

        // リンクを確認
        WebElement helloLink = driver.findElement(By.id("helloLink"));
        assertTrue(helloLink.isDisplayed());
        assertEquals("Hello Servlet", helloLink.getText());
    }

    @Test
    public void testHelloServletDefaultGreeting() {
        driver.get(baseUrl + "/hello");

        // ページタイトルを確認
        String pageTitle = driver.getTitle();
        assertEquals("Hello Servlet", pageTitle);

        // デフォルトの挨拶を確認
        WebElement greetingElement = driver.findElement(By.id("greeting"));
        assertEquals("Hello, World!", greetingElement.getText());
    }

    @Test
    public void testHelloServletWithParameter() {
        driver.get(baseUrl + "/hello?name=Taro");

        // パラメータ付きの挨拶を確認
        WebElement greetingElement = driver.findElement(By.id("greeting"));
        assertEquals("Hello, Taro!", greetingElement.getText());
    }

    @Test
    public void testHelloServletFormSubmission() {
        driver.get(baseUrl + "/hello");

        // フォームに名前を入力
        WebElement nameInput = driver.findElement(By.id("name"));
        nameInput.sendKeys("Hanako");

        // 送信ボタンをクリック
        WebElement submitButton = driver.findElement(By.id("submitBtn"));
        submitButton.click();

        // 入力した名前で挨拶が表示されることを確認
        WebElement greetingElement = driver.findElement(By.id("greeting"));
        assertEquals("Hello, Hanako!", greetingElement.getText());
    }

    @Test
    public void testNavigationFromIndexToHello() {
        driver.get(baseUrl + "/");

        // Hello Servletリンクをクリック
        WebElement helloLink = driver.findElement(By.id("helloLink"));
        helloLink.click();

        // Hello Servletページに遷移したことを確認
        String pageTitle = driver.getTitle();
        assertEquals("Hello Servlet", pageTitle);

        WebElement greetingElement = driver.findElement(By.id("greeting"));
        assertTrue(greetingElement.isDisplayed());
    }
}
