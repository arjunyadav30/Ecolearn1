<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Database connection details
    String url = "jdbc:mysql://localhost/ecolearn";
    String usernameDB = "root";
    String passwordDB = "1234";
    
    int totalStudents = 0;
    int totalSchools = 0;
    int totalTreesPlanted = 0;
    
    Connection con = null;
    PreparedStatement stmt1 = null, stmt2 = null, stmt3 = null;
    ResultSet rs1 = null, rs2 = null, rs3 = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(url, usernameDB, passwordDB);
        
        // Count total students
        stmt1 = con.prepareStatement("SELECT COUNT(*) as studentCount FROM users WHERE user_type = 'Student'");
        rs1 = stmt1.executeQuery();
        if (rs1.next()) {
            totalStudents = rs1.getInt("studentCount");
        }
        
        // Count total schools from schools table (updated to use dedicated schools table)
        stmt2 = con.prepareStatement("SELECT COUNT(*) as schoolCount FROM schools");
        rs2 = stmt2.executeQuery();
        if (rs2.next()) {
            totalSchools = rs2.getInt("schoolCount");
        }
        
        // Check if trees_planted table exists and count trees
        try {
            stmt3 = con.prepareStatement("SELECT COUNT(*) as treeCount FROM trees_planted");
            rs3 = stmt3.executeQuery();
            if (rs3.next()) {
                totalTreesPlanted = rs3.getInt("treeCount");
            }
        } catch (SQLException e) {
            // If trees_planted table doesn't exist, use 0
            totalTreesPlanted = 0;
        }
    } catch (Exception e) {
        // Log the error for debugging
        e.printStackTrace();
        // Use default values in case of error
        totalStudents = 0;
        totalSchools = 0;
        totalTreesPlanted = 0;
    } finally {
        // Close all resources
        try {
            if (rs1 != null) rs1.close();
            if (rs2 != null) rs2.close();
            if (rs3 != null) rs3.close();
            if (stmt1 != null) stmt1.close();
            if (stmt2 != null) stmt2.close();
            if (stmt3 != null) stmt3.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EcoLearn - Gamified Environmental Education Platform</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* EcoLearn - Main Stylesheet */
        :root {
            --primary-green: #2ecc71;
            --secondary-green: #27ae60;
            --dark-green: #16a085;
            --light-green: #a8e6cf;
            --ocean-blue: #3498db;
            --sky-blue: #87ceeb;
            --sunset-orange: #ff7e5f;
            --sunshine-yellow: #feb47b;
            --earth-brown: #8d6e63;
            --white: #ffffff;
            --dark-text: #2c3e50;
            --light-text: #7f8c8d;
            --shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            --border-radius: 15px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: var(--dark-text);
            overflow-x: hidden;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* Animated Background */
        .animated-background {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            background: linear-gradient(135deg, #87ceeb 0%, #98fb98 50%, #90ee90 100%);
            overflow: hidden;
        }

        .floating-leaf {
            position: absolute;
            width: 60px;
            height: 60px;
            background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%2327ae60"><path d="M17,8C8,10 5.9,16.17 3.82,21.34L5.71,22L6.66,19.7C7.14,19.87 7.64,20 8,20C19,20 22,3 22,3C21,5 14,5.25 9,6.25C4,7.25 2,11.5 2,13.5C2,15.5 3.75,17.25 3.75,17.25C7,8 17,8 17,8Z"/></svg>') no-repeat center;
            background-size: contain;
            opacity: 0.2;
            z-index: 1;
        }

        .leaf-1 {
            top: 10%;
            left: -50px;
            animation: floatLeaf 20s infinite linear;
        }

        .leaf-2 {
            top: 40%;
            left: -50px;
            animation: floatLeaf 25s infinite linear;
            animation-delay: 5s;
        }

        .leaf-3 {
            top: 70%;
            left: -50px;
            animation: floatLeaf 22s infinite linear;
            animation-delay: 10s;
        }

        @keyframes floatLeaf {
            from {
                transform: translateX(0) rotate(0deg);
            }
            to {
                transform: translateX(calc(100vw + 100px)) rotate(360deg);
            }
        }

        .floating-cloud {
            position: absolute;
            width: 120px;
            height: 50px;
            background: white;
            border-radius: 100px;
            opacity: 0.3;
            z-index: 1;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }

        .floating-cloud::before {
            content: '';
            position: absolute;
            top: -20px;
            left: 15px;
            width: 60px;
            height: 35px;
            background: white;
            border-radius: 100px;
        }

        .floating-cloud::after {
            content: '';
            position: absolute;
            top: -15px;
            right: 15px;
            width: 50px;
            height: 30px;
            background: white;
            border-radius: 100px;
        }

        .cloud-1 {
            top: 20%;
            animation: floatCloud 35s infinite linear;
        }

        .cloud-2 {
            top: 60%;
            animation: floatCloud 45s infinite linear;
            animation-delay: 15s;
        }

        @keyframes floatCloud {
            from {
                transform: translateX(-150px);
            }
            to {
                transform: translateX(calc(100vw + 150px));
            }
        }

        .sun-rays {
            position: absolute;
            top: -50px;
            right: -50px;
            width: 200px;
            height: 200px;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
            border-radius: 50%;
            animation: pulse 4s infinite ease-in-out;
        }

        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
                opacity: 0.3;
            }
            50% {
                transform: scale(1.1);
                opacity: 0.5;
            }
        }

        /* Navigation */
        .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: var(--shadow);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
            padding: 15px 0;
            transition: all 0.3s ease;
        }

        .navbar.scrolled {
            padding: 10px 0;
            background: rgba(255, 255, 255, 0.98);
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            font-size: 28px;
            font-weight: 800;
            color: var(--primary-green);
            text-decoration: none;
            transition: transform 0.3s ease;
        }

        .logo:hover {
            transform: scale(1.05);
        }

        .logo i {
            margin-right: 12px;
            font-size: 32px;
            color: var(--primary-green);
        }

        .nav-menu {
            display: flex;
            list-style: none;
            align-items: center;
            gap: 35px;
        }

        .nav-menu a {
            text-decoration: none;
            color: var(--dark-text);
            font-weight: 600;
            font-size: 16px;
            transition: all 0.3s ease;
            position: relative;
            padding: 5px 0;
        }

        .nav-menu a::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 2px;
            background: var(--primary-green);
            transition: width 0.3s ease;
        }

        .nav-menu a:hover {
            color: var(--primary-green);
        }

        .nav-menu a:hover::after {
            width: 100%;
        }

        .nav-menu .btn-login, .nav-menu .btn-register {
            padding: 8px 20px;
            border-radius: 25px;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .nav-menu .btn-login {
            border: 2px solid var(--primary-green);
            color: var(--primary-green) !important;
            background: transparent;
        }

        .nav-menu .btn-login:hover {
            background: var(--primary-green);
            color: white !important;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(46, 204, 113, 0.3);
        }

        .nav-menu .btn-register {
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-green));
            color: white !important;
            box-shadow: 0 5px 15px rgba(46, 204, 113, 0.3);
        }

        .nav-menu .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(46, 204, 113, 0.4);
        }

        /* Mobile menu toggle */
        .mobile-menu-toggle {
            display: none;
            font-size: 28px;
            cursor: pointer;
            color: var(--dark-text);
            transition: transform 0.3s ease;
        }

        .mobile-menu-toggle:hover {
            transform: scale(1.1);
            color: var(--primary-green);
        }

        /* Hero Section */
        .hero {
            margin-top: 80px;
            padding: 80px 20px;
            min-height: 90vh;
            display: flex;
            align-items: center;
            justify-content: space-between;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
            position: relative;
            z-index: 2;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: -50px;
            right: -50px;
            width: 200px;
            height: 200px;
            background: radial-gradient(circle, var(--primary-green) 0%, transparent 70%);
            opacity: 0.1;
            z-index: -1;
        }

        .hero-content {
            flex: 1;
            padding-right: 40px;
            position: relative;
            z-index: 2;
        }

        .hero-title {
            font-size: 52px;
            font-weight: 800;
            line-height: 1.2;
            margin-bottom: 25px;
            color: var(--dark-text);
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .hero-title span {
            display: block;
        }

        .hero-title .highlight {
            background: linear-gradient(135deg, var(--primary-green), var(--ocean-blue));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            position: relative;
        }

        .hero-title .highlight::after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 0;
            width: 100%;
            height: 3px;
            background: linear-gradient(135deg, var(--primary-green), var(--ocean-blue));
            border-radius: 2px;
        }

        .hero-subtitle {
            font-size: 22px;
            color: var(--light-text);
            margin-bottom: 45px;
            line-height: 1.7;
        }

        .hero-stats {
            display: flex;
            gap: 50px;
            margin-bottom: 45px;
        }

        .stat-item {
            text-align: center;
            flex: 1;
            transition: transform 0.3s ease;
        }

        .stat-item:hover {
            transform: translateY(-5px);
        }

        .stat-item i {
            font-size: 36px;
            color: var(--primary-green);
            margin-bottom: 15px;
            display: block;
            transition: transform 0.3s ease;
        }

        .stat-item:hover i {
            transform: scale(1.2);
        }

        .stat-number {
            font-size: 32px;
            font-weight: 800;
            color: var(--dark-text);
            display: block;
            margin-bottom: 5px;
        }

        .stat-label {
            font-size: 16px;
            color: var(--light-text);
            font-weight: 500;
        }

        .hero-buttons {
            display: flex;
            gap: 25px;
        }

        .btn {
            padding: 16px 35px;
            border-radius: 35px;
            font-size: 17px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 12px;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            cursor: pointer;
            border: none;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-green));
            color: white;
            position: relative;
            overflow: hidden;
        }

        .btn-primary::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.5s;
        }

        .btn-primary:hover::before {
            left: 100%;
        }

        .btn-primary:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(46, 204, 113, 0.4);
        }

        .btn-secondary {
            background: white;
            color: var(--primary-green);
            border: 2px solid var(--primary-green);
        }

        .btn-secondary:hover {
            background: var(--primary-green);
            color: white;
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(46, 204, 113, 0.3);
        }

        /* Hero Image - Earth Animation */
        .hero-image {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
        }

        .earth-container {
            position: relative;
            width: 450px;
            height: 450px;
        }

        .earth {
            width: 350px;
            height: 350px;
            border-radius: 50%;
            background: linear-gradient(135deg, #3498db, #2ecc71);
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.3), inset -20px -20px 40px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }

        .earth::before {
            content: '';
            position: absolute;
            top: 20%;
            left: 20%;
            width: 30%;
            height: 30%;
            background: rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            filter: blur(5px);
        }

        .rotating {
            animation: rotate 25s infinite linear;
        }

        @keyframes rotate {
            from {
                transform: translate(-50%, -50%) rotate(0deg);
            }
            to {
                transform: translate(-50%, -50%) rotate(360deg);
            }
        }

        .continent {
            position: absolute;
            width: 120px;
            height: 140px;
            background: var(--secondary-green);
            border-radius: 50%;
            top: 30%;
            left: 40%;
            opacity: 0.8;
            box-shadow: inset -5px -5px 10px rgba(0, 0, 0, 0.1);
        }

        .orbit {
            position: absolute;
            width: 450px;
            height: 450px;
            border: 2px dashed rgba(46, 204, 113, 0.4);
            border-radius: 50%;
            animation: rotate 20s infinite linear reverse;
        }

        .eco-icon {
            position: absolute;
            width: 50px;
            height: 50px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
            transition: all 0.3s ease;
        }

        .eco-icon:hover {
            transform: scale(1.2) rotate(10deg);
            box-shadow: 0 12px 25px rgba(0, 0, 0, 0.2);
        }

        .eco-icon i {
            color: var(--primary-green);
            font-size: 24px;
        }

        .icon-1 {
            top: 0;
            left: 50%;
            transform: translateX(-50%);
        }

        .icon-2 {
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
        }

        .icon-3 {
            top: 50%;
            right: 0;
            transform: translateY(-50%);
        }

        /* Features Section */
        .features {
            padding: 100px 0;
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            position: relative;
            overflow: hidden;
        }

        .features::before {
            content: '';
            position: absolute;
            top: -50px;
            left: -50px;
            width: 200px;
            height: 200px;
            background: linear-gradient(135deg, var(--primary-green), var(--ocean-blue));
            border-radius: 50%;
            opacity: 0.1;
            z-index: 1;
        }

        .features::after {
            content: '';
            position: absolute;
            bottom: -80px;
            right: -80px;
            width: 300px;
            height: 300px;
            background: linear-gradient(135deg, var(--sunset-orange), var(--sunshine-yellow));
            border-radius: 50%;
            opacity: 0.1;
            z-index: 1;
        }

        .section-title {
            text-align: center;
            font-size: 42px;
            font-weight: 700;
            margin-bottom: 60px;
            color: var(--dark-text);
            position: relative;
            z-index: 2;
        }

        .section-title::after {
            content: '';
            display: block;
            width: 80px;
            height: 4px;
            background: linear-gradient(135deg, var(--primary-green), var(--ocean-blue));
            margin: 15px auto 0;
            border-radius: 2px;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 35px;
            position: relative;
            z-index: 2;
        }

        .feature-card {
            background: white;
            padding: 40px 30px;
            border-radius: var(--border-radius);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            text-align: center;
            position: relative;
            overflow: hidden;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(135deg, var(--primary-green), var(--ocean-blue));
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.4s ease;
        }

        .feature-card:hover {
            transform: translateY(-15px);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
        }

        .feature-card:hover::before {
            transform: scaleX(1);
        }

        .feature-icon {
            width: 90px;
            height: 90px;
            margin: 0 auto 25px;
            background: linear-gradient(135deg, var(--primary-green), var(--ocean-blue));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 10px 20px rgba(46, 204, 113, 0.3);
            transition: all 0.3s ease;
        }

        .feature-card:hover .feature-icon {
            transform: scale(1.1) rotate(5deg);
            box-shadow: 0 15px 30px rgba(46, 204, 113, 0.4);
        }

        .feature-icon i {
            font-size: 40px;
            color: white;
        }

        .feature-card h3 {
            margin-bottom: 20px;
            color: var(--dark-text);
            font-size: 22px;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .feature-card:hover h3 {
            color: var(--primary-green);
        }

        .feature-card p {
            color: var(--light-text);
            line-height: 1.7;
            font-size: 16px;
            transition: color 0.3s ease;
        }

        .feature-card:hover p {
            color: #555;
        }

        /* How It Works */
        .how-it-works {
            padding: 100px 0;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            position: relative;
        }

        .how-it-works::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100"><circle cx="50" cy="50" r="1" fill="%232ecc71" opacity="0.1"/></svg>');
            opacity: 0.3;
        }

        .journey-path {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1000px;
            margin: 0 auto;
            position: relative;
            padding: 0 20px;
        }

        .journey-step {
            text-align: center;
            z-index: 2;
            flex: 1;
            padding: 0 15px;
        }

        .step-number {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-green));
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 25px;
            font-size: 28px;
            font-weight: bold;
            box-shadow: 0 10px 25px rgba(46, 204, 113, 0.4);
            position: relative;
            transition: all 0.3s ease;
        }

        .step-number::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-green), var(--secondary-green));
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .journey-step:hover .step-number {
            transform: scale(1.1);
            box-shadow: 0 15px 30px rgba(46, 204, 113, 0.6);
        }

        .journey-step:hover .step-number::after {
            opacity: 0.2;
        }

        .step-content h3 {
            margin-bottom: 15px;
            color: var(--dark-text);
            font-size: 20px;
            font-weight: 600;
        }

        .step-content p {
            color: var(--light-text);
            font-size: 15px;
            line-height: 1.6;
        }

        .journey-line {
            position: absolute;
            top: 35px;
            width: calc(100% - 140px);
            height: 3px;
            background: linear-gradient(90deg, var(--primary-green), var(--ocean-blue));
            z-index: 1;
            left: 70px;
            border-radius: 2px;
            box-shadow: 0 2px 5px rgba(46, 204, 113, 0.3);
        }

        /* Challenges Preview */
        .challenges-preview {
            padding: 100px 0;
            background: white;
            position: relative;
        }

        .challenges-preview::before {
            content: '';
            position: absolute;
            top: -100px;
            right: -100px;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, var(--sunshine-yellow) 0%, transparent 70%);
            opacity: 0.1;
        }

        .challenges-carousel {
            display: flex;
            gap: 40px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .challenge-card {
            background: white;
            border-radius: var(--border-radius);
            padding: 35px;
            width: 320px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            position: relative;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .challenge-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border-radius: var(--border-radius);
            background: linear-gradient(135deg, transparent 0%, rgba(46, 204, 113, 0.03) 100%);
            z-index: -1;
        }

        .challenge-card:hover {
            transform: translateY(-15px);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
        }

        .challenge-badge {
            position: absolute;
            top: 20px;
            right: 20px;
            padding: 6px 18px;
            border-radius: 25px;
            font-size: 13px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
        }

        .challenge-card.daily .challenge-badge {
            background: linear-gradient(135deg, var(--sunshine-yellow), #ff9e6d);
            color: white;
        }

        .challenge-card.weekly .challenge-badge {
            background: linear-gradient(135deg, var(--ocean-blue), #5d69d9);
            color: white;
        }

        .challenge-card.special .challenge-badge {
            background: linear-gradient(135deg, var(--sunset-orange), #e65c9c);
            color: white;
        }

        .challenge-icon {
            width: 70px;
            height: 70px;
            margin: 25px auto;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
        }

        .challenge-card:hover .challenge-icon {
            transform: scale(1.1);
            background: linear-gradient(135deg, var(--primary-green), var(--ocean-blue));
        }

        .challenge-card:hover .challenge-icon i {
            color: white;
        }

        .challenge-icon i {
            font-size: 32px;
            color: var(--primary-green);
            transition: all 0.3s ease;
        }

        .challenge-card h3 {
            margin-bottom: 15px;
            color: var(--dark-text);
            font-size: 20px;
            font-weight: 600;
        }

        .challenge-card p {
            color: var(--light-text);
            margin-bottom: 25px;
            font-size: 15px;
            line-height: 1.6;
        }

        .challenge-rewards {
            display: flex;
            justify-content: space-between;
            padding-top: 25px;
            border-top: 1px solid #eee;
        }

        .challenge-rewards span {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            color: var(--dark-text);
            font-weight: 500;
        }

        .challenge-rewards i {
            color: var(--primary-green);
            font-size: 16px;
        }

        /* CTA Section */
        .cta {
            padding: 100px 0;
            background: linear-gradient(135deg, var(--primary-green), var(--ocean-blue));
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .cta::before {
            content: '';
            position: absolute;
            top: -100px;
            left: -100px;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
            border-radius: 50%;
        }

        .cta::after {
            content: '';
            position: absolute;
            bottom: -150px;
            right: -150px;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
            border-radius: 50%;
        }

        .cta h2 {
            font-size: 42px;
            font-weight: 700;
            margin-bottom: 25px;
            position: relative;
            z-index: 2;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }

        .cta p {
            font-size: 22px;
            margin-bottom: 40px;
            opacity: 0.9;
            position: relative;
            z-index: 2;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.6;
        }

        .btn-cta {
            background: white;
            color: var(--primary-green);
            padding: 18px 45px;
            font-size: 20px;
            font-weight: 600;
            border-radius: 35px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            position: relative;
            z-index: 2;
            transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: none;
        }

        .btn-cta:hover {
            transform: translateY(-8px) scale(1.05);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.4);
        }

        .btn-cta i {
            margin-right: 10px;
        }

        /* Footer */
        .footer {
            background: linear-gradient(135deg, #2c3e50 0%, #1a2530 100%);
            color: white;
            padding: 60px 0 30px;
            position: relative;
            overflow: hidden;
        }

        .footer::before {
            content: '';
            position: absolute;
            top: -50px;
            left: -50px;
            width: 200px;
            height: 200px;
            background: radial-gradient(circle, var(--primary-green) 0%, transparent 70%);
            opacity: 0.1;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 40px;
            margin-bottom: 40px;
            position: relative;
            z-index: 2;
        }

        .footer-section h3,
        .footer-section h4 {
            margin-bottom: 25px;
            color: white;
            font-size: 20px;
            font-weight: 600;
            position: relative;
            padding-bottom: 10px;
        }

        .footer-section h3::after,
        .footer-section h4::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 50px;
            height: 3px;
            background: var(--primary-green);
            border-radius: 2px;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 12px;
        }

        .footer-section a {
            color: #bdc3c7;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-block;
            position: relative;
            padding: 2px 0;
        }

        .footer-section a::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 1px;
            background: var(--primary-green);
            transition: width 0.3s ease;
        }

        .footer-section a:hover {
            color: var(--primary-green);
            transform: translateX(5px);
        }

        .footer-section a:hover::after {
            width: 100%;
        }

        .social-links {
            display: flex;
            gap: 18px;
            margin-top: 25px;
        }

        .social-links a {
            width: 45px;
            height: 45px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            color: white;
            font-size: 18px;
        }

        .social-links a:hover {
            background: var(--primary-green);
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(46, 204, 113, 0.4);
        }

        .footer-bottom {
            text-align: center;
            padding-top: 30px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: #bdc3c7;
            font-size: 14px;
            position: relative;
            z-index: 2;
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            .earth-container {
                width: 350px;
                height: 350px;
            }
            
            .earth {
                width: 250px;
                height: 250px;
            }
            
            .orbit {
                width: 350px;
                height: 350px;
            }
        }

        @media (max-width: 992px) {
            .hero {
                flex-direction: column;
                text-align: center;
                padding: 40px 20px;
            }
            
            .hero-content {
                padding-right: 0;
                margin-bottom: 40px;
            }
            
            .hero-title {
                font-size: 40px;
            }
            
            .hero-stats {
                justify-content: center;
                flex-wrap: wrap;
            }
            
            .hero-buttons {
                justify-content: center;
            }
            
            .earth-container {
                width: 300px;
                height: 300px;
            }
            
            .earth {
                width: 200px;
                height: 200px;
            }
            
            .orbit {
                width: 300px;
                height: 300px;
            }
            
            .features-grid {
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            }
            
            .journey-path {
                flex-direction: column;
                gap: 50px;
                padding: 0 15px;
            }
            
            .journey-line {
                display: none;
            }
            
            .section-title {
                font-size: 32px;
            }
            
            .features-grid {
                grid-template-columns: 1fr;
            }
            
            .cta h2 {
                font-size: 28px;
            }
            
            .cta p {
                font-size: 18px;
            }
            
            .challenge-card {
                width: 100%;
                max-width: 350px;
            }
        }

        @media (max-width: 768px) {
            .nav-menu {
                position: fixed;
                top: 70px;
                left: -100%;
                width: 100%;
                height: calc(100vh - 70px);
                background: white;
                flex-direction: column;
                align-items: center;
                padding-top: 40px;
                transition: 0.3s;
                box-shadow: 0 10px 10px rgba(0, 0, 0, 0.1);
                z-index: 1000;
            }
            
            .nav-menu.active {
                left: 0;
            }
            
            .mobile-menu-toggle {
                display: block;
            }
            
            .hero-title {
                font-size: 32px;
            }
            
            .hero-subtitle {
                font-size: 18px;
            }
            
            .hero-stats {
                gap: 20px;
            }
            
            .stat-item {
                flex: 1;
                min-width: 100px;
            }
            
            .stat-number {
                font-size: 24px;
            }
            
            .hero-buttons {
                flex-direction: column;
                gap: 15px;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
            
            .section-title {
                font-size: 28px;
                margin-bottom: 40px;
            }
            
            .feature-card {
                padding: 30px 20px;
            }
            
            .feature-icon {
                width: 70px;
                height: 70px;
                margin: 0 auto 20px;
            }
            
            .feature-icon i {
                font-size: 30px;
            }
            
            .cta h2 {
                font-size: 26px;
            }
            
            .cta p {
                font-size: 16px;
            }
        }

        @media (max-width: 576px) {
            .hero {
                margin-top: 70px;
                padding: 30px 15px;
            }
            
            .hero-title {
                font-size: 28px;
            }
            
            .hero-subtitle {
                font-size: 16px;
            }
            
            .hero-stats {
                flex-direction: column;
                gap: 20px;
            }
            
            .stat-item {
                width: 100%;
            }
            
            .section-title {
                font-size: 24px;
            }
            
            .feature-card {
                padding: 25px 15px;
            }
            
            .challenge-card {
                width: 100%;
                max-width: 300px;
                padding: 25px;
            }
            
            .footer-content {
                grid-template-columns: 1fr;
                gap: 30px;
            }
            
            .challenge-rewards {
                flex-direction: column;
                gap: 10px;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
    <!-- Animated Background -->
    <div class="animated-background">
        <div class="floating-leaf leaf-1"></div>
        <div class="floating-leaf leaf-2"></div>
        <div class="floating-leaf leaf-3"></div>
        <div class="floating-cloud cloud-1"></div>
        <div class="floating-cloud cloud-2"></div>
        <div class="sun-rays"></div>
    </div>

    <!-- Navigation -->
    <nav class="navbar">
        <div class="nav-container">
            <div class="logo">
                <i class="fas fa-leaf"></i>
                <span>EcoLearn</span>
            </div>
            <ul class="nav-menu">
                <li><a href="#features">Features</a></li>
                <li><a href="#how-it-works">How It Works</a></li>
                <li><a href="#challenges">Challenges</a></li>
                <li><a href="#leaderboard">Leaderboard</a></li>
                <li><a href="jsp/register.jsp" class="nav-link nav-link-login">Register</a></li>
                <li><a href="jsp/login.jsp" class="nav-link nav-link-register">Login</a></li>
            </ul>
            <div class="mobile-menu-toggle">
                <i class="fas fa-bars"></i>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <h1 class="hero-title animated-text">
                <span>Save the Planet,</span>
                <span class="highlight">One Challenge at a Time!</span>
            </h1>
            <p class="hero-subtitle">
                Join Punjab's first gamified environmental education platform. 
                Learn, compete, and earn rewards while making a real difference!
            </p>
            <div class="hero-stats">
                <div class="stat-item">
                    <i class="fas fa-users"></i>
                    <span class="stat-number" data-target="<%= totalStudents %>">0</span>
                    <span class="stat-label">Active Students</span>
                </div>
                <div class="stat-item">
                    <i class="fas fa-school"></i>
                    <span class="stat-number" data-target="<%= totalSchools %>">0</span>
                    <span class="stat-label">Schools</span>
                </div>
                <div class="stat-item">
                    <i class="fas fa-tree"></i>
                    <span class="stat-number" data-target="<%= totalTreesPlanted %>">0</span>
                    <span class="stat-label">Trees Planted</span>
                </div>
            </div>
            <div class="hero-buttons">
                <a href="jsp/register.jsp" class="btn btn-primary">
                    <i class="fas fa-rocket"></i> Start Your Journey
                </a>
                <a href="jsp/dashboard.jsp" class="btn btn-secondary">
                    <i class="fas fa-tachometer-alt"></i> View Dashboard
                </a>
            </div>
        </div>
        <div class="hero-image">
            <div class="earth-container">
                <div class="earth rotating">
                    <div class="continent"></div>
                </div>
                <div class="orbit">
                    <div class="eco-icon icon-1"><i class="fas fa-leaf"></i></div>
                    <div class="eco-icon icon-2"><i class="fas fa-water"></i></div>
                    <div class="eco-icon icon-3"><i class="fas fa-solar-panel"></i></div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="features">
        <div class="container">
            <h2 class="section-title">Why EcoLearn is Different</h2>
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-gamepad"></i>
                    </div>
                    <h3>Gamified Learning</h3>
                    <p>Turn environmental education into an exciting adventure with points, badges, and rewards!</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-trophy"></i>
                    </div>
                    <h3>School Competitions</h3>
                    <p>Compete with other schools across Punjab and climb the eco-leaderboard!</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-hands-helping"></i>
                    </div>
                    <h3>Real-World Impact</h3>
                    <p>Complete challenges that make actual environmental impact in your community!</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-film"></i>
                    </div>
                    <h3>Animated Lessons</h3>
                    <p>Learn through fun cartoon animations and interactive 3D experiences!</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-calculator"></i>
                    </div>
                    <h3>Carbon Calculator</h3>
                    <p>Track your carbon footprint and see how your actions reduce emissions!</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-mobile-alt"></i>
                    </div>
                    <h3>AR Plant Scanner</h3>
                    <p>Use AR technology to identify plants and learn about local biodiversity!</p>
                </div>
            </div>
        </div>
    </section>

    <!-- How It Works -->
    <section id="how-it-works" class="how-it-works">
        <div class="container">
            <h2 class="section-title">Your Eco-Journey</h2>
            <div class="journey-path">
                <div class="journey-step">
                    <div class="step-number">1</div>
                    <div class="step-content">
                        <h3>Sign Up</h3>
                        <p>Register with your school and create your eco-avatar</p>
                    </div>
                </div>
                <div class="journey-line"></div>
                <div class="journey-step">
                    <div class="step-number">2</div>
                    <div class="step-content">
                        <h3>Learn</h3>
                        <p>Watch animated lessons and take interactive quizzes</p>
                    </div>
                </div>
                <div class="journey-line"></div>
                <div class="journey-step">
                    <div class="step-number">3</div>
                    <div class="step-content">
                        <h3>Challenge</h3>
                        <p>Complete real-world eco-challenges in your community</p>
                    </div>
                </div>
                <div class="journey-line"></div>
                <div class="journey-step">
                    <div class="step-number">4</div>
                    <div class="step-content">
                        <h3>Earn & Win</h3>
                        <p>Collect eco-points, badges, and climb the leaderboard!</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Sample Challenges -->
    <section id="challenges" class="challenges-preview">
        <div class="container">
            <h2 class="section-title">Featured Challenges</h2>
            <div class="challenges-carousel">
                <div class="challenge-card daily">
                    <div class="challenge-badge">Daily</div>
                    <div class="challenge-icon">
                        <i class="fas fa-bicycle"></i>
                    </div>
                    <h3>Green Commute</h3>
                    <p>Cycle or walk to school for a week</p>
                    <div class="challenge-rewards">
                        <span><i class="fas fa-coins"></i> 50 Points</span>
                        <span><i class="fas fa-leaf"></i> -2kg CO₂</span>
                    </div>
                </div>
                <div class="challenge-card weekly">
                    <div class="challenge-badge">Weekly</div>
                    <div class="challenge-icon">
                        <i class="fas fa-seedling"></i>
                    </div>
                    <h3>Plant a Tree</h3>
                    <p>Plant and nurture a tree in your area</p>
                    <div class="challenge-rewards">
                        <span><i class="fas fa-coins"></i> 200 Points</span>
                        <span><i class="fas fa-tree"></i> +1 Tree</span>
                    </div>
                </div>
                <div class="challenge-card special">
                    <div class="challenge-badge">Special</div>
                    <div class="challenge-icon">
                        <i class="fas fa-trash-restore"></i>
                    </div>
                    <h3>Plastic-Free Week</h3>
                    <p>Avoid single-use plastics for 7 days</p>
                    <div class="challenge-rewards">
                        <span><i class="fas fa-coins"></i> 500 Points</span>
                        <span><i class="fas fa-medal"></i> Badge</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Call to Action -->
    <section class="cta">
        <div class="container">
            <h2>Ready to Make a Difference?</h2>
            <p>Join thousands of students across Punjab in the fight against climate change!</p>
            <a href="jsp/register.jsp" class="btn btn-cta">
                <i class="fas fa-leaf"></i> Start Your Eco-Journey Now
            </a>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>EcoLearn</h3>
                    <p>Empowering Punjab's youth to create a sustainable future through gamified environmental education.</p>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-facebook"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                        <a href="#"><i class="fab fa-youtube"></i></a>
                    </div>
                </div>
                <div class="footer-section">
                    <h4>Quick Links</h4>
                    <ul>
                        <li><a href="#">About Us</a></li>
                        <li><a href="#">For Schools</a></li>
                        <li><a href="#">Resources</a></li>
                        <li><a href="#">Contact</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h4>Support</h4>
                    <ul>
                        <li><a href="#">Help Center</a></li>
                        <li><a href="#">Teacher Portal</a></li>
                        <li><a href="#">Parent Guide</a></li>
                        <li><a href="#">FAQ</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h4>Government of Punjab</h4>
                    <p>Department of Higher Education</p>
                    <p>Smart Education Initiative</p>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2024 EcoLearn. All rights reserved. | Developed for Government of Punjab</p>
            </div>
        </div>
    </footer>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>
    
    <!-- Chatbot CSS -->
    <style>
        .chatbot-container {
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 10000;
        }
        
        .chatbot-toggle {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, var(--primary-green), var(--ocean-blue));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            cursor: pointer;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            transition: all 0.3s ease;
            border: none;
        }
        
        .chatbot-toggle:hover {
            transform: scale(1.1);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.4);
        }
        
        .chatbot-window {
            position: absolute;
            bottom: 70px;
            right: 0;
            width: 350px;
            height: 450px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            display: none;
            flex-direction: column;
            overflow: hidden;
            animation: slideUp 0.3s ease;
        }
        
        .chatbot-window.active {
            display: flex;
        }
        
        .chatbot-header {
            background: linear-gradient(135deg, var(--primary-green), var(--ocean-blue));
            color: white;
            padding: 15px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .chatbot-header h3 {
            margin: 0;
            font-size: 18px;
            font-weight: 600;
        }
        
        .chatbot-close {
            background: none;
            border: none;
            color: white;
            font-size: 20px;
            cursor: pointer;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: background 0.3s;
        }
        
        .chatbot-close:hover {
            background: rgba(255, 255, 255, 0.2);
        }
        
        .chatbot-messages {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .message {
            max-width: 80%;
            padding: 12px 15px;
            border-radius: 18px;
            font-size: 14px;
            line-height: 1.4;
            position: relative;
            animation: fadeIn 0.3s ease;
        }
        
        .bot-message {
            background: #f1f1f1;
            align-self: flex-start;
            border-bottom-left-radius: 5px;
        }
        
        .user-message {
            background: linear-gradient(135deg, var(--primary-green), var(--ocean-blue));
            color: white;
            align-self: flex-end;
            border-bottom-right-radius: 5px;
        }
        
        .chatbot-input {
            display: flex;
            padding: 15px;
            border-top: 1px solid #eee;
            background: white;
        }
        
        .chatbot-input input {
            flex: 1;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 25px;
            outline: none;
            font-size: 14px;
        }
        
        .chatbot-input input:focus {
            border-color: var(--primary-green);
        }
        
        .chatbot-input button {
            background: linear-gradient(135deg, var(--primary-green), var(--ocean-blue));
            color: white;
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            margin-left: 10px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: transform 0.2s;
        }
        
        .chatbot-input button:hover {
            transform: scale(1.05);
        }
        
        .chatbot-input button i {
            font-size: 16px;
        }
        
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }
        
        .typing-indicator {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            background: #f1f1f1;
            border-radius: 18px;
            align-self: flex-start;
            border-bottom-left-radius: 5px;
        }
        
        .typing-dot {
            width: 8px;
            height: 8px;
            background: #888;
            border-radius: 50%;
            margin: 0 2px;
            animation: typing 1.4s infinite ease-in-out;
        }
        
        .typing-dot:nth-child(1) {
            animation-delay: 0s;
        }
        
        .typing-dot:nth-child(2) {
            animation-delay: 0.2s;
        }
        
        .typing-dot:nth-child(3) {
            animation-delay: 0.4s;
        }
        
        @keyframes typing {
            0%, 60%, 100% {
                transform: translateY(0);
            }
            30% {
                transform: translateY(-5px);
            }
        }
    </style>

    <!-- Chatbot Container -->
    <div class="chatbot-container">
        <button class="chatbot-toggle" id="chatbotToggle">
            <i class="fas fa-robot"></i>
        </button>
        <div class="chatbot-window" id="chatbotWindow">
            <div class="chatbot-header">
                <h3>EcoLearn Assistant</h3>
                <button class="chatbot-close" id="chatbotClose">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="chatbot-messages" id="chatbotMessages">
                <div class="message bot-message">
                    Hello! I'm your EcoLearn assistant. How can I help you today? You can ask me about:
                    <ul style="margin: 10px 0 0 20px; padding: 0;">
                        <li>Our features</li>
                        <li>How to get started</li>
                        <li>Environmental challenges</li>
                        <li>Learning resources</li>
                    </ul>
                </div>
            </div>
            <div class="chatbot-input">
                <input type="text" id="chatbotInput" placeholder="Type your message here...">
                <button id="chatbotSend">
                    <i class="fas fa-paper-plane"></i>
                </button>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>
    
    <script>
        // Mobile menu toggle
        document.addEventListener('DOMContentLoaded', function() {
            const mobileToggle = document.querySelector('.mobile-menu-toggle');
            const navMenu = document.querySelector('.nav-menu');
            
            if (mobileToggle) {
                mobileToggle.addEventListener('click', function() {
                    navMenu.classList.toggle('active');
                    this.querySelector('i').classList.toggle('fa-bars');
                    this.querySelector('i').classList.toggle('fa-times');
                });
            }
            
            // Close mobile menu when clicking on a link
            const navLinks = document.querySelectorAll('.nav-menu a');
            navLinks.forEach(link => {
                link.addEventListener('click', function() {
                    navMenu.classList.remove('active');
                    document.querySelector('.mobile-menu-toggle i').classList.add('fa-bars');
                    document.querySelector('.mobile-menu-toggle i').classList.remove('fa-times');
                });
            });
            
            // Navbar scroll effect
            window.addEventListener('scroll', function() {
                const navbar = document.querySelector('.navbar');
                if (window.scrollY > 50) {
                    navbar.classList.add('scrolled');
                } else {
                    navbar.classList.remove('scrolled');
                }
            });
            
            // Initialize counters with a small delay to ensure DOM is ready
            setTimeout(function() {
                initializeCounters();
            }, 100);
        });
        
        // Chatbot functionality
        document.addEventListener('DOMContentLoaded', function() {
            // Wait a bit more for all elements to be ready
            setTimeout(function() {
                const chatbotToggle = document.getElementById('chatbotToggle');
                const chatbotWindow = document.getElementById('chatbotWindow');
                const chatbotClose = document.getElementById('chatbotClose');
                const chatbotInput = document.getElementById('chatbotInput');
                const chatbotSend = document.getElementById('chatbotSend');
                const chatbotMessages = document.getElementById('chatbotMessages');
                
                // Check if all elements exist
                if (chatbotToggle && chatbotWindow && chatbotClose && chatbotInput && chatbotSend && chatbotMessages) {
                    // Toggle chatbot window
                    chatbotToggle.addEventListener('click', function() {
                        chatbotWindow.classList.toggle('active');
                    });
                    
                    // Close chatbot window
                    chatbotClose.addEventListener('click', function() {
                        chatbotWindow.classList.remove('active');
                    });
                    
                    // Send message on button click
                    chatbotSend.addEventListener('click', sendMessage);
                    
                    // Send message on Enter key
                    chatbotInput.addEventListener('keypress', function(e) {
                        if (e.key === 'Enter') {
                            sendMessage();
                        }
                    });
                    
                    // Function to send message
                    function sendMessage() {
                        const message = chatbotInput.value.trim();
                        if (message) {
                            // Add user message
                            addMessage(message, 'user');
                            chatbotInput.value = '';
                            
                            // Show typing indicator
                            showTypingIndicator();
                            
                            // Get bot response after a short delay
                            setTimeout(() => {
                                removeTypingIndicator();
                                const response = getBotResponse(message);
                                addMessage(response, 'bot');
                            }, 1000);
                        }
                    }
                    
                    // Function to add message to chat
                    function addMessage(text, sender) {
                        const messageDiv = document.createElement('div');
                        messageDiv.classList.add('message');
                        messageDiv.classList.add(sender + '-message');
                        messageDiv.textContent = text;
                        chatbotMessages.appendChild(messageDiv);
                        chatbotMessages.scrollTop = chatbotMessages.scrollHeight;
                    }
                    
                    // Function to show typing indicator
                    function showTypingIndicator() {
                        const typingDiv = document.createElement('div');
                        typingDiv.classList.add('typing-indicator');
                        typingDiv.id = 'typingIndicator';
                        typingDiv.innerHTML = `
                            <div class="typing-dot"></div>
                            <div class="typing-dot"></div>
                            <div class="typing-dot"></div>
                        `;
                        chatbotMessages.appendChild(typingDiv);
                        chatbotMessages.scrollTop = chatbotMessages.scrollHeight;
                    }
                    
                    // Function to remove typing indicator
                    function removeTypingIndicator() {
                        const typingIndicator = document.getElementById('typingIndicator');
                        if (typingIndicator) {
                            typingIndicator.remove();
                        }
                    }
                    
                    // Function to get bot response
                    function getBotResponse(message) {
                        const lowerMessage = message.toLowerCase();
                        
                        // Responses for different keywords
                        if (lowerMessage.includes('hello') || lowerMessage.includes('hi') || lowerMessage.includes('hey')) {
                            return "Hello there! I'm here to help you learn about EcoLearn. What would you like to know?";
                        } else if (lowerMessage.includes('feature') || lowerMessage.includes('what can')) {
                            return "EcoLearn offers several amazing features: 1) Gamified learning with points and badges, 2) School competitions with leaderboards, 3) Real-world environmental challenges, 4) Animated lessons, 5) Carbon footprint calculator, and 6) AR plant scanner. Which feature interests you most?";
                        } else if (lowerMessage.includes('start') || lowerMessage.includes('begin') || lowerMessage.includes('register')) {
                            return "Getting started is easy! Click the 'Start Your Journey' button on our homepage to register. You'll create an eco-avatar, join your school, and begin learning about environmental conservation through fun activities and challenges.";
                        } else if (lowerMessage.includes('challenge') || lowerMessage.includes('activity')) {
                            return "Our challenges include: 1) Green Commute - cycling or walking to school, 2) Plant a Tree - nurturing a tree in your area, 3) Plastic-Free Week - avoiding single-use plastics, and 4) Energy Conservation - reducing electricity usage. Each challenge earns you eco-points and helps the environment!";
                        } else if (lowerMessage.includes('learn') || lowerMessage.includes('lesson') || lowerMessage.includes('study')) {
                            return "Our lessons cover important environmental topics through fun animations: 1) Renewable Energy Sources, 2) Climate Change and Its Effects, 3) Biodiversity Conservation, 4) Waste Management, 5) Sustainable Agriculture, and 6) Water Conservation. Each lesson includes interactive quizzes to test your knowledge.";
                        } else if (lowerMessage.includes('point') || lowerMessage.includes('reward')) {
                            return "You earn eco-points by completing lessons, challenges, and games. Points help you level up from Seedling to Eco Warrior! You can also earn badges for achievements. Your points contribute to both your personal progress and your school's ranking on our leaderboard.";
                        } else if (lowerMessage.includes('game') || lowerMessage.includes('play')) {
                            return "We have several educational games: 1) Eco Sorting Challenge - learn to sort waste properly, 2) Carbon Footprint Quest - understand your environmental impact, 3) Biodiversity Builder - protect endangered species, and 4) Energy Saver - learn about renewable energy. Games are both fun and educational!";
                        } else if (lowerMessage.includes('thank')) {
                            return "You're welcome! Is there anything else I can help you with regarding EcoLearn?";
                        } else {
                            return "I'm here to help you learn about EcoLearn! You can ask me about our features, how to get started, environmental challenges, learning resources, or anything else related to our platform. What would you like to know?";
                        }
                    }
                }
            }, 200);
        });
        
        function initializeCounters() {
            const counters = document.querySelectorAll('.stat-number');
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const counter = entry.target;
                        const target = parseInt(counter.getAttribute('data-target')) || 0;
                        if (target > 0) {
                            animateCounter(counter, target);
                            observer.unobserve(counter);
                        }
                    }
                });
            }, { threshold: 0.1 });
            
            counters.forEach(counter => {
                observer.observe(counter);
            });
        }
        
        function animateCounter(counter, target) {
            const duration = 2000;
            const increment = target / (duration / 16);
            let current = 0;
            counter.innerText = '0';
            
            const updateCounter = () => {
                current += increment;
                if (current < target) {
                    counter.innerText = Math.ceil(current).toLocaleString();
                    requestAnimationFrame(updateCounter);
                } else {
                    counter.innerText = target.toLocaleString();
                }
            };
            
            updateCounter();
        }
    </script>
</body>
</html>