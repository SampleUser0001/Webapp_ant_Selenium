<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Webアプリテストサンプル</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
        }
        h1 {
            color: #333;
        }
        .container {
            background-color: #f5f5f5;
            padding: 20px;
            border-radius: 5px;
        }
        .link-section {
            margin-top: 20px;
        }
        a {
            display: inline-block;
            margin: 10px 0;
            padding: 10px 15px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 3px;
        }
        a:hover {
            background-color: #0056b3;
        }
        #message {
            margin-top: 20px;
            padding: 10px;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            border-radius: 3px;
            color: #155724;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 id="title">Webアプリテストサンプル</h1>
        <p>Tomcat + JUnit + Seleniumのサンプルアプリケーションへようこそ</p>

        <div id="message">
            <strong>ステータス:</strong> アプリケーションは正常に動作しています
        </div>

        <div class="link-section">
            <h2>サンプルページ</h2>
            <a href="hello" id="helloLink">Hello Servlet</a>
        </div>
    </div>
</body>
</html>
