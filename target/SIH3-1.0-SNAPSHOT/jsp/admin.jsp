<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Panel</title>
    <link rel="stylesheet" href="../css/main.css">
    <link rel="stylesheet" href="../css/animations.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            background: linear-gradient(135deg, #2c3e50, #34495e);
            color: #ecf0f1;
            display: flex;
            flex-direction: column;
        }
        
        header {
            background: linear-gradient(135deg, #27ae60, #2ecc71);
            color: white;
            padding: 20px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }
        
        header h1 {
            margin: 0;
            font-size: 28px;
            animation: fadeInDown 1s ease-out;
        }
        
        main {
            flex: 1;
            padding: 40px 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        
        .dashboard-section {
            text-align: center;
            margin-bottom: 40px;
            animation: fadeInUp 1s ease-out;
        }
        
        .features {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
            max-width: 1000px;
            width: 100%;
        }
        
        .feature-card {
            background: #34495e;
            border-radius: 12px;
            padding: 25px;
            width: 280px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            animation: fadeInUp 1.5s ease-out;
        }
        
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
        }
        
        .feature-card h3 {
            color: #2ecc71;
            margin-bottom: 15px;
            font-size: 20px;
        }
        
        .feature-card p {
            color: #bdc3c7;
            font-size: 14px;
            line-height: 1.5;
        }
        
        footer {
            background: #2c3e50;
            text-align: center;
            padding: 15px;
            font-size: 13px;
            color: #95a5a6;
            margin-top: auto;
            box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.2);
        }
        
        /* Animations */
        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .animated {
            opacity: 0;
            animation: fadeInUp 1s ease-out forwards;
        }
        
        .feature-card:nth-child(1) { animation-delay: 0.2s; }
        .feature-card:nth-child(2) { animation-delay: 0.4s; }
        .feature-card:nth-child(3) { animation-delay: 0.6s; }
    </style>
</head>
<body>
    <header>
        <h1>Admin Panel</h1>
    </header>

    <main>
        <section class="dashboard-section">
            <h2>Welcome, Administrator</h2>
            <p>Manage users, content, and settings across the platform.</p>
        </section>

        <section class="features">
            <div class="feature-card animated">
                <h3>User Management</h3>
                <p>Add, remove, or edit user accounts and roles (students, teachers).</p>
            </div>
            <div class="feature-card animated">
                <h3>Content Management</h3>
                <p>Update lessons, games, and environmental educational materials.</p>
            </div>
            <div class="feature-card animated">
                <h3>System Settings</h3>
                <p>Configure global settings, themes, and application behavior.</p>
            </div>
        </section>
    </main>

    <footer>
        <p>&copy; 2025 EcoLearn Platform</p>
    </footer>
</body>
</html>