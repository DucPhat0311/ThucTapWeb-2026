/*
 Navicat Premium Dump SQL

 Source Server         : ClotheStore_conn
 Source Server Type    : MySQL
 Source Server Version : 80407 (8.4.7)
 Source Host           : localhost:3306
 Source Schema         : aurastudio

 Target Server Type    : MySQL
 Target Server Version : 80407 (8.4.7)
 File Encoding         : 65001

 Date: 20/03/2026 15:04:02
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for addresses
-- ----------------------------
DROP TABLE IF EXISTS `addresses`;
CREATE TABLE `addresses`  (
                              `id` int NOT NULL AUTO_INCREMENT,
                              `user_id` int NOT NULL,
                              `receiver_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                              `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                              `city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                              `district` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                              `ward` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                              `detail_address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
                              `default_address` tinyint(1) NULL DEFAULT 0,
                              `active` tinyint(1) NULL DEFAULT 1,
                              PRIMARY KEY (`id`) USING BTREE,
                              INDEX `user_id`(`user_id` ASC) USING BTREE,
                              CONSTRAINT `addresses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of addresses
-- ----------------------------
INSERT INTO `addresses` VALUES (1, 2, 'Nguyễn Văn A', '0123456789', 'HCM', 'Thủ Đức', 'Linh Trung', 'KTX A', 1, 1);
INSERT INTO `addresses` VALUES (2, 3, 'Trần Thị B', '0987654321', 'Hà Nội', 'Cầu Giấy', 'Dịch Vọng', 'Số 10', 1, 1);

-- ----------------------------
-- Table structure for banners
-- ----------------------------
DROP TABLE IF EXISTS `banners`;
CREATE TABLE `banners`  (
                            `id` int NOT NULL AUTO_INCREMENT,
                            `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                            `navigate_to` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                            `title` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                            `status` tinyint(1) NULL DEFAULT 1,
                            `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
                            PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of banners
-- ----------------------------

-- ----------------------------
-- Table structure for cart_items
-- ----------------------------
DROP TABLE IF EXISTS `cart_items`;
CREATE TABLE `cart_items`  (
                               `id` int NOT NULL AUTO_INCREMENT,
                               `cart_id` int NOT NULL,
                               `product_id` int NOT NULL,
                               `variant_id` int NOT NULL,
                               `quantity` int NOT NULL DEFAULT 1,
                               `price` double NOT NULL,
                               PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of cart_items
-- ----------------------------

-- ----------------------------
-- Table structure for carts
-- ----------------------------
DROP TABLE IF EXISTS `carts`;
CREATE TABLE `carts`  (
                          `id` int NOT NULL AUTO_INCREMENT,
                          `user_id` int NOT NULL,
                          `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
                          PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of carts
-- ----------------------------
INSERT INTO `carts` VALUES (1, 2, '2026-03-19 20:15:25');
INSERT INTO `carts` VALUES (2, 3, '2026-03-19 20:32:03');
INSERT INTO `carts` VALUES (3, 5, '2026-03-19 21:51:16');
INSERT INTO `carts` VALUES (4, 6, '2026-03-19 22:48:56');

-- ----------------------------
-- Table structure for categories
-- ----------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories`  (
                               `id` int NOT NULL AUTO_INCREMENT,
                               `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                               `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
                               `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                               `status` int NULL DEFAULT 1,
                               PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of categories
-- ----------------------------
INSERT INTO `categories` VALUES (1, 'Áo thun', 'Áo thun các loại', NULL, 1);
INSERT INTO `categories` VALUES (2, 'Quần jean', 'Jean nam nữ', NULL, 1);
INSERT INTO `categories` VALUES (3, 'Áo khoác', 'Hoodie, jacket', NULL, 1);
INSERT INTO `categories` VALUES (4, 'Sơ mi', 'Áo sơ mi công sở', NULL, 1);

-- ----------------------------
-- Table structure for colors
-- ----------------------------
DROP TABLE IF EXISTS `colors`;
CREATE TABLE `colors`  (
                           `id` int NOT NULL AUTO_INCREMENT,
                           `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                           `hex` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                           PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of colors
-- ----------------------------
INSERT INTO `colors` VALUES (1, 'Đen', '#000');
INSERT INTO `colors` VALUES (2, 'Trắng', '#FFF');
INSERT INTO `colors` VALUES (3, 'Đỏ', '#F00');
INSERT INTO `colors` VALUES (4, 'Xanh', '#00F');

-- ----------------------------
-- Table structure for contacts
-- ----------------------------
DROP TABLE IF EXISTS `contacts`;
CREATE TABLE `contacts`  (
                             `id` int NOT NULL AUTO_INCREMENT,
                             `user_id` int NULL DEFAULT NULL,
                             `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                             `email` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                             `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                             `address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
                             `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
                             `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'Chưa xử lý',
                             `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
                             PRIMARY KEY (`id`) USING BTREE,
                             INDEX `user_id`(`user_id` ASC) USING BTREE,
                             CONSTRAINT `contacts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of contacts
-- ----------------------------

-- ----------------------------
-- Table structure for news
-- ----------------------------
DROP TABLE IF EXISTS `news`;
CREATE TABLE `news`  (
                         `id` int NOT NULL AUTO_INCREMENT,
                         `author_id` int NULL DEFAULT NULL,
                         `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                         `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                         `thumbnail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                         `short_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
                         `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
                         `status` int NULL DEFAULT 1,
                         `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
                         `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                         PRIMARY KEY (`id`) USING BTREE,
                         UNIQUE INDEX `slug`(`slug` ASC) USING BTREE,
                         INDEX `author_id`(`author_id` ASC) USING BTREE,
                         CONSTRAINT `news_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of news
-- ----------------------------

-- ----------------------------
-- Table structure for order_items
-- ----------------------------
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items`  (
                                `id` int NOT NULL AUTO_INCREMENT,
                                `order_id` int NOT NULL,
                                `variant_id` int NOT NULL,
                                `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                                `size` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                                `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                                `thumbnail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                                `quantity` int NULL DEFAULT NULL,
                                `price` decimal(10, 2) NULL DEFAULT NULL,
                                `total` decimal(10, 2) NULL DEFAULT NULL,
                                PRIMARY KEY (`id`) USING BTREE,
                                INDEX `order_id`(`order_id` ASC) USING BTREE,
                                INDEX `variant_id`(`variant_id` ASC) USING BTREE,
                                CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
                                CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of order_items
-- ----------------------------
INSERT INTO `order_items` VALUES (1, 1, 1, 'Áo thun đen basic', 'M', 'Đen', NULL, 2, 150000.00, 300000.00);
INSERT INTO `order_items` VALUES (2, 2, 7, 'Áo sơ mi trắng', 'M', 'Trắng', NULL, 3, 300000.00, 900000.00);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
                           `id` int NOT NULL AUTO_INCREMENT,
                           `user_id` int NOT NULL,
                           `receiver_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                           `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                           `shipping_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                           `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
                           `total_price` decimal(10, 2) NOT NULL,
                           `discount` decimal(10, 2) NULL DEFAULT 0.00,
                           `shipping_fee` decimal(10, 2) NULL DEFAULT 0.00,
                           `final_amount` decimal(10, 2) NOT NULL,
                           `payment_methods` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                           `payment_statuses` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'Chưa thanh toán',
                           `order_status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'Chờ xác nhận',
                           `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
                           PRIMARY KEY (`id`) USING BTREE,
                           INDEX `user_id`(`user_id` ASC) USING BTREE,
                           CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (1, 6, 'Đức Phát Nguyễn', '0982832647', 'Đức Pfsshát Nguyễn', '', 300000.00, 0.00, 0.00, 300000.00, 'COD', 'UNPAID', 'PENDING', '2026-03-19 22:51:34');
INSERT INTO `orders` VALUES (2, 6, 'Đức Phát Nguyễn', '0982832647', '260/1B đường Nguyễn Thái Bình phường 12 quận tân bình', '1a', 900000.00, 0.00, 0.00, 900000.00, 'COD', 'UNPAID', 'PENDING', '2026-03-20 10:08:30');

-- ----------------------------
-- Table structure for product_images
-- ----------------------------
DROP TABLE IF EXISTS `product_images`;
CREATE TABLE `product_images`  (
                                   `id` int NOT NULL AUTO_INCREMENT,
                                   `product_id` int NOT NULL,
                                   `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                                   `is_main` tinyint(1) NULL DEFAULT 0,
                                   PRIMARY KEY (`id`) USING BTREE,
                                   INDEX `product_id`(`product_id` ASC) USING BTREE,
                                   CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of product_images
-- ----------------------------
INSERT INTO `product_images` VALUES (1, 1, 'ao1.jpg', 1);
INSERT INTO `product_images` VALUES (2, 1, 'ao1_2.jpg', 0);
INSERT INTO `product_images` VALUES (3, 2, 'ao2.jpg', 1);
INSERT INTO `product_images` VALUES (4, 3, 'quan1.jpg', 1);
INSERT INTO `product_images` VALUES (5, 4, 'quan2.jpg', 1);
INSERT INTO `product_images` VALUES (6, 5, 'hoodie1.jpg', 1);
INSERT INTO `product_images` VALUES (7, 6, 'somi1.jpg', 1);

-- ----------------------------
-- Table structure for product_variants
-- ----------------------------
DROP TABLE IF EXISTS `product_variants`;
CREATE TABLE `product_variants`  (
                                     `id` int NOT NULL AUTO_INCREMENT,
                                     `product_id` int NOT NULL,
                                     `size_id` int NOT NULL,
                                     `color_id` int NOT NULL,
                                     `stock` int NULL DEFAULT 0,
                                     `price` decimal(10, 2) NULL DEFAULT NULL,
                                     `sale_price` decimal(10, 2) NULL DEFAULT NULL,
                                     PRIMARY KEY (`id`) USING BTREE,
                                     UNIQUE INDEX `product_id`(`product_id` ASC, `size_id` ASC, `color_id` ASC) USING BTREE,
                                     INDEX `size_id`(`size_id` ASC) USING BTREE,
                                     INDEX `color_id`(`color_id` ASC) USING BTREE,
                                     CONSTRAINT `product_variants_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
                                     CONSTRAINT `product_variants_ibfk_2` FOREIGN KEY (`size_id`) REFERENCES `sizes` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
                                     CONSTRAINT `product_variants_ibfk_3` FOREIGN KEY (`color_id`) REFERENCES `colors` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of product_variants
-- ----------------------------
INSERT INTO `product_variants` VALUES (1, 1, 2, 1, 48, 200000.00, 150000.00);
INSERT INTO `product_variants` VALUES (2, 1, 3, 2, 40, 200000.00, 150000.00);
INSERT INTO `product_variants` VALUES (3, 2, 2, 2, 30, 220000.00, 180000.00);
INSERT INTO `product_variants` VALUES (4, 3, 2, 4, 25, 500000.00, 450000.00);
INSERT INTO `product_variants` VALUES (5, 4, 3, 1, 20, 520000.00, 480000.00);
INSERT INTO `product_variants` VALUES (6, 5, 3, 3, 15, 600000.00, 550000.00);
INSERT INTO `product_variants` VALUES (7, 6, 2, 2, 32, 350000.00, 300000.00);

-- ----------------------------
-- Table structure for products
-- ----------------------------
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products`  (
                             `id` int NOT NULL AUTO_INCREMENT,
                             `category_id` int NOT NULL,
                             `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                             `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
                             `price` decimal(10, 2) NOT NULL,
                             `sale_price` decimal(10, 2) NULL DEFAULT 0.00,
                             `thumbnail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                             `views` int NULL DEFAULT 0,
                             `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'Đang bán',
                             `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
                             PRIMARY KEY (`id`) USING BTREE,
                             INDEX `category_id`(`category_id` ASC) USING BTREE,
                             CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of products
-- ----------------------------
INSERT INTO `products` VALUES (1, 1, 'Áo thun đen basic', 'Cotton 100%', 200000.00, 150000.00, 'ao1.jpg', 0, 'Đang bán', '2026-03-19 22:00:28');
INSERT INTO `products` VALUES (2, 1, 'Áo thun trắng form rộng', 'Unisex', 220000.00, 180000.00, 'ao2.jpg', 0, 'Đang bán', '2026-03-19 22:00:28');
INSERT INTO `products` VALUES (3, 2, 'Quần jean xanh', 'Slim fit', 500000.00, 450000.00, 'quan1.jpg', 0, 'Đang bán', '2026-03-19 22:00:28');
INSERT INTO `products` VALUES (4, 2, 'Quần jean đen', 'Skinny', 520000.00, 480000.00, 'quan2.jpg', 0, 'Đang bán', '2026-03-19 22:00:28');
INSERT INTO `products` VALUES (5, 3, 'Hoodie xám', 'Form rộng', 600000.00, 550000.00, 'hoodie1.jpg', 0, 'Đang bán', '2026-03-19 22:00:28');
INSERT INTO `products` VALUES (6, 4, 'Áo sơ mi trắng', 'Công sở', 350000.00, 300000.00, 'somi1.jpg', 0, 'Đang bán', '2026-03-19 22:00:28');

-- ----------------------------
-- Table structure for reviews
-- ----------------------------
DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews`  (
                            `id` int NOT NULL AUTO_INCREMENT,
                            `product_id` int NOT NULL,
                            `user_id` int NOT NULL,
                            `rating` int NULL DEFAULT NULL,
                            `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
                            `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
                            PRIMARY KEY (`id`) USING BTREE,
                            INDEX `product_id`(`product_id` ASC) USING BTREE,
                            INDEX `user_id`(`user_id` ASC) USING BTREE,
                            CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
                            CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of reviews
-- ----------------------------
INSERT INTO `reviews` VALUES (1, 1, 2, 5, 'Rất đẹp', '2026-03-19 22:12:30');
INSERT INTO `reviews` VALUES (2, 2, 3, 4, 'Ổn áp', '2026-03-19 22:12:30');
INSERT INTO `reviews` VALUES (3, 3, 2, 5, 'Chất lượng tốt', '2026-03-19 22:12:30');

-- ----------------------------
-- Table structure for sizes
-- ----------------------------
DROP TABLE IF EXISTS `sizes`;
CREATE TABLE `sizes`  (
                          `id` int NOT NULL AUTO_INCREMENT,
                          `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                          `sort_order` int NULL DEFAULT 0,
                          PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sizes
-- ----------------------------
INSERT INTO `sizes` VALUES (1, 'S', 1);
INSERT INTO `sizes` VALUES (2, 'M', 2);
INSERT INTO `sizes` VALUES (3, 'L', 3);
INSERT INTO `sizes` VALUES (4, 'XL', 4);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
                          `id` int NOT NULL AUTO_INCREMENT,
                          `username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                          `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                          `email` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                          `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USER',
                          `full_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                          `birthday` date NULL DEFAULT NULL,
                          `gender` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                          `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                          `address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
                          `otp_code` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                          `is_active` tinyint NULL DEFAULT 0,
                          `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
                          `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
                          `otp_expired_at` datetime NULL DEFAULT NULL,
                          PRIMARY KEY (`id`) USING BTREE,
                          UNIQUE INDEX `username`(`username` ASC) USING BTREE,
                          UNIQUE INDEX `email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (3, 'thutran2002', '$2a$12$CC3jSe2l0hdq9FnKu2KvhO66sfVvqRqPpO24CXIAgWP33pANVrPjq', '23130318@st.hcmuaf.edu.vn', 'USER', NULL, NULL, NULL, NULL, NULL, NULL, 1, 'ACTIVE', '2026-03-19 20:31:38', NULL);
INSERT INTO `users` VALUES (6, 'ducphat', '$2a$12$NHCT38prp9zIxJK88qlhA.I/.9hzdJKZx6VvKacQ/hGobCfJDjHM6', 'ducphat0311@gmail.com', 'USER', NULL, NULL, NULL, NULL, NULL, NULL, 1, 'ACTIVE', '2026-03-19 22:48:16', NULL);

SET FOREIGN_KEY_CHECKS = 1;
