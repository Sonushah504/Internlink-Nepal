ALTER TABLE users MODIFY COLUMN password_hash VARCHAR(255) NULL;

ALTER TABLE users ADD COLUMN auth_provider ENUM('LOCAL','GOOGLE','FACEBOOK') NOT NULL DEFAULT 'LOCAL';

CREATE TABLE IF NOT EXISTS password_reset_otps (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NOT NULL,
    otp_code    VARCHAR(12) NOT NULL,
    expires_at  DATETIME NOT NULL,
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_reset_user (user_id),
    INDEX idx_reset_expires (expires_at)
);
