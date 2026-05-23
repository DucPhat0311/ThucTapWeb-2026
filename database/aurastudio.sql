/*
 Navicat Premium Data Transfer

 Source Server         : MySQL_Django
 Source Server Type    : MySQL
 Source Server Version : 80043 (8.0.43)
 Source Host           : localhost:3306
 Source Schema         : aurastudio

 Target Server Type    : MySQL
 Target Server Version : 80043 (8.0.43)
 File Encoding         : 65001

 Date: 01/05/2026 19:30:03
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
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `province_code` int NULL DEFAULT NULL,
  `district` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `district_code` int NULL DEFAULT NULL,
  `ward` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `ward_code` int NULL DEFAULT NULL,
  `detailAddress` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `is_default` tinyint(1) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `addresses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of addresses
-- ----------------------------
INSERT INTO `addresses` VALUES (1, 3, 'qưeqwe', '0974123624', 'Hồ Chí Minh', NULL, 'Quận 3', NULL, 'Phường 2', NULL, 'ytccuy', 0);
INSERT INTO `addresses` VALUES (3, 3, 'qưewqeqweqwe', '0523875448', 'Bình Dương', NULL, 'Thuận An', NULL, 'Lái Thiêu', NULL, 'qưeqeqweqweqw', 1);
INSERT INTO `addresses` VALUES (14, 8, 'Nguyen Van Anh Han', '0900142141', 'Tỉnh Quảng Ninh', 22, 'Huyện Cô Tô', 207, 'Thị trấn Cô Tô', 7192, 'số 11 lý thái tổ', 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of banners
-- ----------------------------
INSERT INTO `banners` VALUES (1, './img/2.jpg', 'WF', 'FWEWE', 0, '2026-03-21 00:42:40');

-- ----------------------------
-- Table structure for blogs
-- ----------------------------
DROP TABLE IF EXISTS `blogs`;
CREATE TABLE `blogs`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `author_id` int NULL DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `status` int NULL DEFAULT 1,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `author_id`(`author_id` ASC) USING BTREE,
  CONSTRAINT `blogs_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of blogs
-- ----------------------------
INSERT INTO `blogs` VALUES (1, 1, 'Gợi ý phối đồ với HADES INVERTED TEE', 'img/products/NU/AOTHUN/HADES INVERTED TEE/main.jpg', 'Khám phá cách phối đồ đẹp và hiện đại với sản phẩm HADES INVERTED TEE, giúp bạn tự tin hơn trong nhiều hoàn cảnh khác nhau.', '<p><strong>HADES INVERTED TEE</strong> là một trong những item thời trang dễ ứng dụng trong nhiều phong cách khác nhau, từ năng động, trẻ trung đến thanh lịch, hiện đại.</p><p>Nếu bạn đang tìm kiếm một gợi ý phối đồ đơn giản nhưng vẫn nổi bật, thì đây là lựa chọn rất đáng để tham khảo. Với thiết kế dễ mặc, màu sắc hài hòa và tính ứng dụng cao, sản phẩm này có thể kết hợp cùng nhiều item có sẵn trong tủ đồ của bạn.</p><p>Bạn có thể phối cùng quần jean, quần kaki hoặc chân váy để tạo nên tổng thể cân đối và thu hút. Ngoài ra, việc kết hợp thêm giày sneaker, túi xách hoặc phụ kiện tối giản cũng sẽ giúp outfit trở nên hoàn thiện hơn.</p><p>Không chỉ phù hợp để đi học, đi làm hay đi chơi, sản phẩm này còn mang lại sự thoải mái khi mặc hằng ngày. Đây là kiểu trang phục vừa đảm bảo tính thẩm mỹ, vừa đáp ứng nhu cầu sử dụng thực tế.</p><p>Nếu bạn yêu thích phong cách thời trang hiện đại và muốn làm mới bản thân mỗi ngày, hãy thử bắt đầu từ những item cơ bản nhưng dễ phối như <strong>HADES INVERTED TEE</strong>.</p>', 1, '2026-03-30 13:51:42', '2026-03-30 13:51:42');
INSERT INTO `blogs` VALUES (2, 1, 'Phối đồ năng động với Ao Khoac Nu That Belt Form Straight', 'img/products/NU/AOKHOAC/ao-khoac-nu-that-belt-form-straight/main.jpg', 'Gợi ý phối đồ trẻ trung, năng động với sản phẩm Ao Khoac Nu That Belt Form Straight.', '<p><strong>Ao Khoac Nu That Belt Form Straight</strong> là lựa chọn phù hợp cho những ai yêu thích phong cách năng động và hiện đại.</p><p>Bạn có thể kết hợp sản phẩm này cùng quần jean hoặc quần short để tạo nên tổng thể trẻ trung, thoải mái nhưng vẫn thời trang.</p><p>Nếu muốn outfit thêm nổi bật, hãy phối cùng sneaker trắng, túi đeo chéo và một vài phụ kiện đơn giản.</p><p>Đây là kiểu trang phục phù hợp cho đi học, đi chơi, dạo phố hoặc gặp gỡ bạn bè cuối tuần.</p>', 1, '2026-03-30 13:55:31', '2026-03-30 13:55:31');
INSERT INTO `blogs` VALUES (3, 1, 'Bí quyết mặc đẹp cùng SWE EAZY OFF-SHOULDER CROP', 'img/products/NU/AOKIEUNU/SWE EAZY OFF-SHOULDER CROP/main.jpg', 'Khám phá cách mặc đẹp hơn mỗi ngày với SWE EAZY OFF-SHOULDER CROP.', '<p><strong>SWE EAZY OFF-SHOULDER CROP</strong> không chỉ là một món đồ thời trang mà còn là gợi ý tuyệt vời để làm mới phong cách cá nhân.</p><p>Thiết kế dễ mặc giúp bạn có thể phối với nhiều item khác nhau mà không mất quá nhiều thời gian lựa chọn.</p><p>Khi kết hợp cùng quần dáng suông hoặc chân váy tối giản, tổng thể trang phục sẽ trở nên hài hòa và tinh tế hơn.</p><p>Đây là lựa chọn phù hợp cho những ai muốn vừa mặc đẹp vừa giữ được sự thoải mái trong sinh hoạt hằng ngày.</p>', 1, '2026-03-30 13:55:31', '2026-03-30 13:55:31');
INSERT INTO `blogs` VALUES (4, 1, 'Cách phối outfit nổi bật với SWE FLOW TUBE TOP', 'img/products/NU/AOKIEUNU/SWE FLOW TUBE TOP/main.jpg', 'Một vài gợi ý giúp bạn phối outfit nổi bật hơn với SWE FLOW TUBE TOP.', '<p><strong>SWE FLOW TUBE TOP</strong> là item có tính ứng dụng cao và phù hợp với nhiều phong cách thời trang khác nhau.</p><p>Bạn có thể phối cùng quần jean xanh, quần kaki sáng màu hoặc chân váy để tạo nên sự khác biệt cho trang phục.</p><p>Nếu yêu thích vẻ ngoài hiện đại, hãy kết hợp thêm giày thể thao, đồng hồ hoặc túi xách nhỏ gọn.</p><p>Sự đơn giản trong cách phối sẽ giúp bạn dễ mặc nhưng vẫn giữ được nét cuốn hút riêng.</p>', 1, '2026-03-30 13:55:31', '2026-03-30 13:55:31');
INSERT INTO `blogs` VALUES (5, 1, 'Trang phục hằng ngày với SWE HONEY EDGE BRA', 'img/products/NU/AOKIEUNU/SWE HONEY EDGE BRA/main.jpg', 'Gợi ý lựa chọn trang phục hằng ngày cùng SWE HONEY EDGE BRA.', '<p><strong>SWE HONEY EDGE BRA</strong> là kiểu trang phục phù hợp với nhu cầu mặc đẹp mỗi ngày.</p><p>Không cần phối quá cầu kỳ, chỉ với một vài item cơ bản bạn đã có thể tạo nên set đồ chỉn chu và hiện đại.</p><p>Sản phẩm này phù hợp cho môi trường học tập, làm việc nhẹ nhàng hoặc các buổi gặp gỡ bạn bè.</p><p>Nếu bạn đang tìm kiếm một món đồ dễ ứng dụng, đây chắc chắn là gợi ý đáng để tham khảo.</p>', 1, '2026-03-30 13:55:31', '2026-03-30 13:55:31');
INSERT INTO `blogs` VALUES (6, 1, 'Gợi ý mix & match cùng SWE OG BAND SPORT BRA', 'img/products/NU/AOKIEUNU/SWE OG BAND SPORT BRA/main.jpg', 'Làm mới phong cách với những cách mix & match đơn giản cùng SWE OG BAND SPORT BRA.', '<p><strong>SWE OG BAND SPORT BRA</strong> mang đến cảm giác trẻ trung, hiện đại và rất dễ phối đồ.</p><p>Bạn có thể kết hợp sản phẩm này với quần dài basic, áo khoác nhẹ hoặc phụ kiện tối giản để tạo điểm nhấn.</p><p>Một set đồ đẹp không nhất thiết phải quá cầu kỳ, quan trọng là sự hài hòa giữa màu sắc và kiểu dáng.</p><p>Hãy bắt đầu từ những item cơ bản như <strong>SWE OG BAND SPORT BRA</strong> để xây dựng phong cách riêng cho bản thân.</p>', 1, '2026-03-30 13:55:31', '2026-03-30 13:55:31');
INSERT INTO `blogs` VALUES (7, 1, 'Mặc gì đẹp với Ao Hai Day Denim Nu Cot No Form Regular?', 'img/products/NU/AOKIEUNU/ao-hai-day-denim-nu-cot-no-form-regular/main.jpg', 'Tham khảo ngay những cách phối đẹp với Ao Hai Day Denim Nu Cot No Form Regular.', '<p><strong>Ao Hai Day Denim Nu Cot No Form Regular</strong> là item lý tưởng cho những ai yêu thích sự đơn giản nhưng vẫn muốn nổi bật.</p><p>Khi phối cùng các trang phục cơ bản như quần jean, quần kaki hoặc chân váy, tổng thể sẽ trở nên cân đối và dễ nhìn hơn.</p><p>Bạn cũng có thể kết hợp với giày sneaker hoặc sandal tùy theo hoàn cảnh sử dụng.</p><p>Đây là kiểu trang phục dễ mặc, dễ ứng dụng và phù hợp với nhiều độ tuổi khác nhau.</p>', 1, '2026-03-30 13:55:31', '2026-03-30 13:55:31');
INSERT INTO `blogs` VALUES (8, 1, 'Xu hướng phối đồ mới với HADES INVERTED TEE', 'img/products/NU/AOTHUN/HADES INVERTED TEE/main.jpg', 'Cập nhật xu hướng phối đồ mới cùng HADES INVERTED TEE.', '<p><strong>HADES INVERTED TEE</strong> là item có thể giúp bạn bắt kịp xu hướng thời trang hiện đại một cách dễ dàng.</p><p>Sự linh hoạt trong kiểu dáng giúp sản phẩm này phù hợp với nhiều cách phối khác nhau, từ casual đến thanh lịch.</p><p>Bạn có thể tạo điểm nhấn bằng một chiếc túi nhỏ, đồng hồ hoặc đôi giày phù hợp với màu sắc trang phục.</p><p>Chỉ cần một vài thay đổi nhỏ, outfit hằng ngày của bạn sẽ trở nên mới mẻ và thu hút hơn rất nhiều.</p>', 1, '2026-03-30 13:55:31', '2026-03-30 13:55:31');
INSERT INTO `blogs` VALUES (9, 1, 'Phối đồ tối giản cùng HADES NO ENTRY TEE', 'img/products/NU/AOTHUN/HADES NO ENTRY TEE/main.jpg', 'Phong cách tối giản nhưng vẫn cuốn hút với HADES NO ENTRY TEE.', '<p><strong>HADES NO ENTRY TEE</strong> là lựa chọn phù hợp cho phong cách tối giản đang được nhiều người yêu thích.</p><p>Với thiết kế dễ mặc và không lỗi thời, sản phẩm này giúp bạn tiết kiệm thời gian khi chọn đồ mỗi ngày.</p><p>Khi phối cùng những gam màu trung tính, tổng thể trang phục sẽ trông hài hòa, thanh lịch và hiện đại hơn.</p><p>Đây là gợi ý rất phù hợp cho những ai muốn xây dựng hình ảnh chỉn chu nhưng không quá cầu kỳ.</p>', 1, '2026-03-30 13:55:31', '2026-03-30 13:55:31');
INSERT INTO `blogs` VALUES (10, 1, 'Làm mới phong cách với HADES WHISPER RACERBACK', 'img/products/NU/AOTHUN/HADES WHISPER RACERBACK/main.jpg', 'Một gợi ý thú vị để làm mới phong cách cá nhân cùng HADES WHISPER RACERBACK.', '<p><strong>HADES WHISPER RACERBACK</strong> là item giúp bạn dễ dàng thay đổi diện mạo theo hướng trẻ trung và cuốn hút hơn.</p><p>Dù phối theo phong cách đơn giản hay năng động, sản phẩm này vẫn giữ được tính thẩm mỹ và sự tiện dụng.</p><p>Bạn có thể kết hợp cùng quần dài, quần short hoặc các phụ kiện nhỏ để outfit thêm phần nổi bật.</p><p>Đây là kiểu sản phẩm rất đáng có trong tủ đồ nếu bạn muốn mặc đẹp hơn mỗi ngày mà không quá phức tạp.</p>', 1, '2026-03-30 13:55:31', '2026-03-30 13:55:31');
INSERT INTO `blogs` VALUES (11, 1, 'Phong cách trẻ trung cùng Ao Thun Nu Crop Tay Ngan Co Nhan Metal Form Fitted', 'img/products/NU/AOTHUN/ao-thun-nu-crop-tay-ngan-co-nhan-metal-form-fitted/main.jpg', 'Khám phá cách xây dựng phong cách trẻ trung và hiện đại với Ao Thun Nu Crop Tay Ngan Co Nhan Metal Form Fitted.', '<p><strong>Ao Thun Nu Crop Tay Ngan Co Nhan Metal Form Fitted</strong> là item phù hợp với những ai yêu thích sự trẻ trung, năng động và dễ ứng dụng trong cuộc sống hằng ngày.</p><p>Bạn có thể phối sản phẩm này với quần jean, quần kaki hoặc chân váy để tạo nên tổng thể hài hòa và bắt mắt hơn.</p><p>Nếu muốn outfit thêm phần nổi bật, hãy kết hợp cùng giày sneaker trắng, túi xách nhỏ hoặc đồng hồ tối giản.</p><p>Đây là lựa chọn thích hợp cho đi học, đi chơi, dạo phố hay gặp gỡ bạn bè vào cuối tuần.</p>', 1, '2026-03-30 13:58:19', '2026-03-30 13:58:19');
INSERT INTO `blogs` VALUES (12, 1, 'Gợi ý mặc đẹp mỗi ngày với Ao Thun Nu Crop Tay Ngan Cotton Theu Chu Regular', 'img/products/NU/AOTHUN/ao-thun-nu-crop-tay-ngan-cotton-theu-chu-regular/main.jpg', 'Tham khảo ngay cách mặc đẹp đơn giản nhưng hiệu quả cùng Ao Thun Nu Crop Tay Ngan Cotton Theu Chu Regular.', '<p><strong>Ao Thun Nu Crop Tay Ngan Cotton Theu Chu Regular</strong> là gợi ý tuyệt vời cho những ai muốn mặc đẹp mỗi ngày mà không cần phối đồ quá cầu kỳ.</p><p>Thiết kế dễ mặc giúp sản phẩm này phù hợp với nhiều hoàn cảnh khác nhau, từ đi học, đi làm đến đi chơi nhẹ nhàng.</p><p>Bạn có thể kết hợp cùng quần basic và phụ kiện đơn giản để tạo nên một outfit thanh lịch nhưng vẫn giữ được nét hiện đại.</p><p>Đây là kiểu item nên có trong tủ đồ vì vừa dễ ứng dụng vừa mang lại cảm giác tự tin khi mặc.</p>', 1, '2026-03-30 13:58:19', '2026-03-30 13:58:19');
INSERT INTO `blogs` VALUES (13, 1, 'Cách phối đồ thanh lịch với Ao Thun Nu Tay Ngan 100 Cotton Phoi Vien Tay Co', 'img/products/NU/AOTHUN/ao-thun-nu-tay-ngan-100-cotton-phoi-vien-tay-co/main.jpg', 'Biến outfit hằng ngày trở nên thanh lịch hơn cùng Ao Thun Nu Tay Ngan 100 Cotton Phoi Vien Tay Co.', '<p><strong>Ao Thun Nu Tay Ngan 100 Cotton Phoi Vien Tay Co</strong> là item mang đến cảm giác chỉn chu và phù hợp với phong cách thanh lịch hiện đại.</p><p>Khi phối cùng quần dài sáng màu hoặc chân váy tối giản, trang phục sẽ trở nên cân đối và tinh tế hơn rất nhiều.</p><p>Bạn cũng có thể kết hợp thêm túi xách nhỏ, đồng hồ hoặc giày đơn sắc để tổng thể thêm phần hài hòa.</p><p>Đây là lựa chọn phù hợp cho những ai muốn xây dựng hình ảnh gọn gàng, dễ nhìn nhưng vẫn có điểm nhấn riêng.</p>', 1, '2026-03-30 13:58:19', '2026-03-30 13:58:19');
INSERT INTO `blogs` VALUES (14, 1, 'Lựa chọn đáng thử với Ao Thun Nu Tay Ngan Cotton Ke Soc Ngang Regular', 'img/products/NU/AOTHUN/ao-thun-nu-tay-ngan-cotton-ke-soc-ngang-regular/main.jpg', 'Một item đáng thử nếu bạn muốn làm mới phong cách với Ao Thun Nu Tay Ngan Cotton Ke Soc Ngang Regular.', '<p><strong>Ao Thun Nu Tay Ngan Cotton Ke Soc Ngang Regular</strong> không chỉ đơn thuần là một món đồ thời trang mà còn là gợi ý thú vị để làm mới phong cách cá nhân.</p><p>Sản phẩm này có thể phối theo nhiều hướng khác nhau, từ đơn giản, năng động cho đến thanh lịch và hiện đại.</p><p>Chỉ cần kết hợp cùng những item cơ bản có sẵn trong tủ đồ, bạn đã có thể tạo nên set đồ đẹp mắt và dễ ứng dụng.</p><p>Nếu bạn đang muốn thay đổi diện mạo theo hướng mới mẻ hơn, đây là item rất đáng để thử.</p>', 1, '2026-03-30 13:58:19', '2026-03-30 13:58:19');
INSERT INTO `blogs` VALUES (15, 1, 'Mix đồ đơn giản với Ao Thun Nu Vai Texture Fitted', 'img/products/NU/AOTHUN/ao-thun-nu-vai-texture-fitted/main.jpg', 'Thử ngay những cách mix đồ đơn giản nhưng vẫn nổi bật cùng Ao Thun Nu Vai Texture Fitted.', '<p><strong>Ao Thun Nu Vai Texture Fitted</strong> là sản phẩm có tính ứng dụng cao và phù hợp với nhiều phong cách phối đồ hiện nay.</p><p>Bạn có thể kết hợp cùng quần jean, quần kaki hoặc các phụ kiện nhỏ để tạo điểm nhấn mà không làm outfit trở nên rối mắt.</p><p>Sự đơn giản trong cách phối chính là yếu tố giúp trang phục trở nên tinh tế và dễ mặc hơn trong nhiều hoàn cảnh khác nhau.</p><p>Đây là lựa chọn phù hợp cho những ai yêu thích sự gọn gàng, hiện đại và tiện lợi trong thời trang hằng ngày.</p>', 1, '2026-03-30 13:58:19', '2026-03-30 13:58:19');
INSERT INTO `blogs` VALUES (16, 1, 'Gợi ý phối đồ cuối tuần cùng HADES ENLISTED ZIP HOODIE', 'img/products/Nam/AOKHOAC/HADES ENLISTED ZIP HOODIE/main.jpg', 'Một lựa chọn dễ mặc, dễ phối và phù hợp cho những ngày xuống phố nhẹ nhàng cùng HADES ENLISTED ZIP HOODIE.', '<p>Trong nhịp sống hiện đại, việc lựa chọn một trang phục vừa đẹp mắt vừa dễ ứng dụng luôn là điều được nhiều người quan tâm. <strong>HADES ENLISTED ZIP HOODIE</strong> là một gợi ý phù hợp cho những ai yêu thích phong cách trẻ trung nhưng không quá cầu kỳ.</p><p>Điểm nổi bật của sản phẩm nằm ở khả năng kết hợp linh hoạt với nhiều item quen thuộc như quần jean, quần kaki, chân váy hoặc áo khoác mỏng. Chỉ cần thay đổi một vài phụ kiện nhỏ như túi xách, giày sneaker hay đồng hồ, bạn đã có thể tạo ra một tổng thể hoàn toàn khác biệt.</p><p>Đây là kiểu trang phục phù hợp cho những buổi cà phê cuối tuần, dạo phố hoặc gặp gỡ bạn bè. Sự thoải mái khi mặc cùng tính thẩm mỹ cân đối giúp sản phẩm trở thành một lựa chọn đáng có trong tủ đồ hằng ngày.</p><p>Nếu bạn đang tìm kiếm một item dễ mặc nhưng vẫn đủ nổi bật để thể hiện gu thẩm mỹ riêng, thì <strong>HADES ENLISTED ZIP HOODIE</strong> là điểm khởi đầu rất đáng thử.</p>', 1, '2026-03-30 14:01:49', '2026-03-30 14:01:49');
INSERT INTO `blogs` VALUES (17, 1, 'Phong cách tối giản nhưng cuốn hút với HADES INDUSRTRIAL EDGE HOODIE', 'img/products/Nam/AOKHOAC/HADES INDUSRTRIAL EDGE HOODIE/main.jpg', 'Khám phá cách xây dựng phong cách tối giản, thanh lịch và hiện đại cùng HADES INDUSRTRIAL EDGE HOODIE.', '<p>Không phải lúc nào thời trang cũng cần đến những chi tiết quá phức tạp. Nhiều khi, sự cuốn hút lại đến từ những item đơn giản nhưng được lựa chọn đúng cách. <strong>HADES INDUSRTRIAL EDGE HOODIE</strong> là ví dụ điển hình cho tinh thần đó.</p><p>Thiết kế dễ mặc, dễ phối giúp sản phẩm phù hợp với nhiều hoàn cảnh khác nhau, từ đi học, đi làm đến những dịp gặp gỡ thường ngày. Khi kết hợp cùng các gam màu trung tính hoặc phụ kiện tối giản, tổng thể trang phục sẽ trở nên hài hòa và tinh tế hơn.</p><p>Một outfit đẹp không nhất thiết phải quá nổi bật. Điều quan trọng là cảm giác vừa vặn, thoải mái và thể hiện được cá tính người mặc. Với những ai yêu thích phong cách chỉn chu nhưng nhẹ nhàng, đây là item rất phù hợp để bắt đầu.</p><p>Hãy thử làm mới tủ đồ của bạn bằng những lựa chọn cơ bản nhưng hiệu quả, và <strong>HADES INDUSRTRIAL EDGE HOODIE</strong> chắc chắn là một gợi ý đáng cân nhắc.</p>', 1, '2026-03-30 14:01:49', '2026-03-30 14:01:49');
INSERT INTO `blogs` VALUES (18, 1, 'Một item đáng thử cho tủ đồ hiện đại: HADES OBSTREPEROUS VARSITY JACKET', 'img/products/Nam/AOKHOAC/HADES OBSTREPEROUS VARSITY JACKET/main.jpg', 'Nếu bạn đang muốn làm mới phong cách cá nhân, HADES OBSTREPEROUS VARSITY JACKET là item rất đáng để tham khảo.', '<p>Mỗi mùa đều có những món đồ trở thành điểm nhấn cho phong cách thường ngày, và <strong>HADES OBSTREPEROUS VARSITY JACKET</strong> là một trong số đó. Sản phẩm mang tinh thần hiện đại, dễ ứng dụng và phù hợp với nhiều kiểu phối đồ khác nhau.</p><p>Bạn có thể kết hợp sản phẩm này với những món đồ quen thuộc có sẵn trong tủ quần áo để tạo nên diện mạo mới mẻ hơn mà không cần thay đổi quá nhiều. Sự linh hoạt trong cách phối chính là yếu tố khiến item này trở nên đáng giá.</p><p>Với những ai yêu thích thời trang theo hướng gọn gàng, dễ mặc và có tính sử dụng cao, đây là lựa chọn rất phù hợp. Trang phục đẹp không chỉ nằm ở vẻ ngoài mà còn ở cảm giác tự tin khi mặc nó trong đời sống hằng ngày.</p><p>Chỉ cần một vài thay đổi nhỏ trong cách phối, <strong>HADES OBSTREPEROUS VARSITY JACKET</strong> có thể giúp bạn làm mới hình ảnh của mình một cách tự nhiên và hiệu quả.</p>', 1, '2026-03-30 14:01:49', '2026-03-30 14:01:49');
INSERT INTO `blogs` VALUES (19, 1, 'Mặc đẹp mỗi ngày bắt đầu từ HADES REIGN VELVET JACKET', 'img/products/Nam/AOKHOAC/HADES REIGN VELVET JACKET/main.jpg', 'Một gợi ý thời trang thực tế, dễ ứng dụng và phù hợp cho nhịp sống hằng ngày với HADES REIGN VELVET JACKET.', '<p>Thời trang hằng ngày không chỉ cần đẹp mà còn phải phù hợp với nhịp sống năng động. <strong>HADES REIGN VELVET JACKET</strong> mang đến cảm giác cân bằng giữa sự tiện dụng và tính thẩm mỹ, giúp người mặc dễ dàng ứng dụng trong nhiều hoàn cảnh.</p><p>Sản phẩm có thể được phối theo nhiều hướng khác nhau: trẻ trung với quần jean và sneaker, thanh lịch với quần dài và túi nhỏ, hoặc nhẹ nhàng hơn khi đi cùng các phụ kiện tối giản. Chính sự linh hoạt này khiến món đồ trở nên hữu ích trong tủ đồ hiện đại.</p><p>Thay vì chạy theo những xu hướng quá ngắn hạn, lựa chọn các item có tính ứng dụng cao sẽ giúp bạn xây dựng phong cách bền vững hơn. Đây cũng là cách mặc đẹp mà vẫn tiết kiệm và thực tế.</p><p>Nếu bạn đang tìm một món đồ có thể đồng hành lâu dài trong nhiều dịp khác nhau, <strong>HADES REIGN VELVET JACKET</strong> là lựa chọn không nên bỏ qua.</p>', 1, '2026-03-30 14:01:49', '2026-03-30 14:01:49');
INSERT INTO `blogs` VALUES (20, 1, 'Gợi ý mặc đẹp theo phong cách trẻ trung với HADES TACTICAL CAMO JACKET', 'img/products/Nam/AOKHOAC/HADES TACTICAL CAMO JACKET/main.jpg', 'Tham khảo một cách phối đồ trẻ trung, năng động nhưng vẫn đủ tinh tế với HADES TACTICAL CAMO JACKET.', '<p>Phong cách trẻ trung luôn có sức hút riêng bởi sự thoải mái, gần gũi nhưng vẫn rất dễ tạo dấu ấn cá nhân. <strong>HADES TACTICAL CAMO JACKET</strong> là lựa chọn phù hợp cho những ai muốn theo đuổi vẻ ngoài năng động mà không làm mất đi sự chỉn chu.</p><p>Khi phối cùng quần basic, giày thể thao và một vài phụ kiện nhỏ, sản phẩm sẽ giúp tổng thể trang phục trở nên hài hòa và hiện đại hơn. Bạn không cần quá nhiều chi tiết cầu kỳ để tạo nên một outfit đẹp.</p><p>Điểm quan trọng trong cách mặc trẻ trung là sự cân đối giữa màu sắc, kiểu dáng và cảm giác thoải mái khi sử dụng. Một item phù hợp sẽ giúp bạn tự tin hơn rất nhiều trong những hoạt động thường ngày.</p><p>Với tính ứng dụng cao và khả năng phối hợp linh hoạt, <strong>HADES TACTICAL CAMO JACKET</strong> là một gợi ý rất đáng thử cho những ai muốn làm mới bản thân theo hướng tích cực hơn.</p>', 1, '2026-03-30 14:01:49', '2026-03-30 14:01:49');
INSERT INTO `blogs` VALUES (21, 1, 'Cảm hứng xuống phố với HADES TRANZIT TRACK JACKET', 'img/products/Nam/AOKHOAC/HADES TRANZIT TRACK JACKET/main.jpg', 'Một item phù hợp cho những ngày dạo phố, gặp gỡ bạn bè và tận hưởng phong cách sống hiện đại cùng HADES TRANZIT TRACK JACKET.', '<p>Một bộ trang phục đẹp cho những buổi xuống phố không cần quá phức tạp, nhưng nên mang lại cảm giác thoải mái và dễ tạo thiện cảm. <strong>HADES TRANZIT TRACK JACKET</strong> là mẫu sản phẩm đáp ứng khá tốt điều đó.</p><p>Sự linh hoạt trong cách phối giúp bạn dễ dàng biến hóa theo nhiều tinh thần khác nhau: năng động, cá tính hoặc tối giản. Chỉ cần kết hợp cùng quần phù hợp và một đôi giày đúng kiểu, tổng thể đã đủ để tạo nên vẻ ngoài tự tin và thu hút.</p><p>Đây cũng là kiểu item thích hợp cho những ai không muốn mất quá nhiều thời gian chọn đồ nhưng vẫn muốn mình xuất hiện chỉn chu. Tính thực tế trong cách mặc là điều khiến sản phẩm trở nên đáng giá.</p><p>Nếu bạn yêu thích những outfit nhẹ nhàng, hiện đại và dễ ứng dụng cho cuộc sống hằng ngày, hãy thử bắt đầu với <strong>HADES TRANZIT TRACK JACKET</strong>.</p>', 1, '2026-03-30 14:01:49', '2026-03-30 14:01:49');
INSERT INTO `blogs` VALUES (22, 1, 'Làm mới phong cách cá nhân cùng HADES VOID DRIFTER ZIP HOODIE', 'img/products/Nam/AOKHOAC/HADES VOID DRIFTER ZIP HOODIE/main.jpg', 'Một lựa chọn phù hợp để làm mới gu ăn mặc và tạo cảm giác tự tin hơn mỗi ngày với HADES VOID DRIFTER ZIP HOODIE.', '<p>Không ít người muốn thay đổi phong cách nhưng thường bắt đầu bằng những lựa chọn quá khó ứng dụng. Thực tế, việc làm mới hình ảnh đôi khi chỉ cần bắt đầu từ một item phù hợp như <strong>HADES VOID DRIFTER ZIP HOODIE</strong>.</p><p>Thiết kế của sản phẩm mang lại sự cân bằng giữa tính thời trang và khả năng sử dụng thực tế. Bạn có thể phối theo kiểu đơn giản cho đời sống hằng ngày, hoặc thêm điểm nhấn bằng phụ kiện để tạo ra cảm giác mới mẻ hơn.</p><p>Điều quan trọng nhất trong thời trang không phải là mặc thật nổi bật, mà là mặc sao cho phù hợp với cá tính và hoàn cảnh. Một item đúng với nhu cầu sẽ giúp bạn tự tin hơn rất nhiều mà không cần gượng ép.</p><p><strong>HADES VOID DRIFTER ZIP HOODIE</strong> là gợi ý phù hợp cho những ai muốn xây dựng phong cách riêng từ những lựa chọn vừa đẹp mắt vừa dễ ứng dụng.</p>', 1, '2026-03-30 14:01:49', '2026-03-30 14:01:49');
INSERT INTO `blogs` VALUES (23, 1, 'Tạo điểm nhấn nhẹ nhàng với HADES WASHED MATRIX JACKET', 'img/products/Nam/AOKHOAC/HADES WASHED MATRIX JACKET/main.jpg', 'Một bài viết gợi ý cách tạo điểm nhấn tinh tế trong outfit hằng ngày cùng HADES WASHED MATRIX JACKET.', '<p>Không phải lúc nào thời trang cũng cần sự phô trương. Nhiều outfit đẹp đến từ những điểm nhấn rất nhẹ nhàng nhưng được đặt đúng chỗ. <strong>HADES WASHED MATRIX JACKET</strong> là một item có thể làm tốt vai trò đó.</p><p>Sản phẩm phù hợp với nhiều cách phối đồ khác nhau, đặc biệt khi đi cùng các món đồ cơ bản. Nhờ vậy, bạn có thể tạo nên vẻ ngoài hài hòa mà vẫn không bị đơn điệu. Một đôi giày phù hợp hoặc chiếc túi nhỏ cũng đủ để hoàn thiện tổng thể.</p><p>Thời trang đẹp là khi người mặc cảm thấy thoải mái và tự tin trong lựa chọn của mình. Với những ai yêu thích sự tinh tế, gọn gàng nhưng vẫn muốn có nét riêng, đây là một item rất nên có.</p><p>Hãy thử đưa <strong>HADES WASHED MATRIX JACKET</strong> vào outfit hằng ngày để cảm nhận sự khác biệt đến từ những chi tiết tưởng chừng rất nhỏ.</p>', 1, '2026-03-30 14:01:49', '2026-03-30 14:01:49');
INSERT INTO `blogs` VALUES (24, 1, 'Gợi ý phối đồ dễ áp dụng với Ao Khoac Aston', 'img/products/Nam/AOKHOAC/ao-khoac-aston/main.jpg', 'Những cách phối đồ đơn giản, thực tế nhưng vẫn đẹp mắt với Ao Khoac Aston.', '<p>Một trong những tiêu chí quan trọng khi chọn trang phục là khả năng áp dụng vào đời sống hằng ngày. <strong>Ao Khoac Aston</strong> là sản phẩm đáp ứng tốt yêu cầu đó nhờ kiểu dáng dễ mặc và khả năng kết hợp linh hoạt.</p><p>Thay vì suy nghĩ quá nhiều về việc mặc gì cho phù hợp, bạn có thể bắt đầu từ những item dễ phối như thế này. Chỉ cần kết hợp với quần basic, chân váy hoặc áo khoác nhẹ là đã có thể tạo nên một tổng thể đẹp mắt và gọn gàng.</p><p>Những outfit đơn giản thường có ưu điểm là không lỗi thời và dễ khiến người mặc cảm thấy tự nhiên hơn. Đây cũng là hướng đi phù hợp nếu bạn muốn xây dựng hình ảnh chỉn chu nhưng không quá phô trương.</p><p>Với tính ứng dụng cao, <strong>Ao Khoac Aston</strong> hoàn toàn có thể trở thành món đồ đồng hành lâu dài trong nhiều dịp khác nhau.</p>', 1, '2026-03-30 14:01:49', '2026-03-30 14:01:49');
INSERT INTO `blogs` VALUES (25, 1, 'Một lựa chọn thời trang đáng chú ý: Ao Khoac Nam Jacky', 'img/products/Nam/AOKHOAC/ao-khoac-nam-jacky/main.jpg', 'Thêm một gợi ý thời trang đáng chú ý cho tủ đồ hiện đại với Ao Khoac Nam Jacky.', '<p>Giữa rất nhiều lựa chọn thời trang hiện nay, những sản phẩm vừa đẹp, vừa dễ mặc luôn có chỗ đứng riêng. <strong>Ao Khoac Nam Jacky</strong> là một trong những item như vậy.</p><p>Sản phẩm mang đến cảm giác hiện đại, dễ kết hợp và phù hợp với nhiều nhu cầu khác nhau. Bạn có thể mặc trong những buổi gặp gỡ bạn bè, đi học, đi làm hoặc đơn giản là muốn xuất hiện chỉn chu hơn trong sinh hoạt hằng ngày.</p><p>Sự hấp dẫn của món đồ này không nằm ở những chi tiết phức tạp, mà ở chính khả năng thích nghi với nhiều kiểu phối. Đó là lý do vì sao những item có tính ứng dụng cao luôn được yêu thích lâu dài.</p><p>Nếu bạn đang tìm kiếm một sản phẩm vừa đẹp mắt vừa thực tế để bổ sung cho tủ đồ, <strong>Ao Khoac Nam Jacky</strong> là gợi ý rất phù hợp để bắt đầu.</p>', 1, '2026-03-30 14:01:49', '2026-03-30 14:01:49');

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
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of cart_items
-- ----------------------------
INSERT INTO `cart_items` VALUES (8, 2, 1, 1, 1, 180000);
INSERT INTO `cart_items` VALUES (9, 2, 2, 5, 2, 399000);
INSERT INTO `cart_items` VALUES (21, 7, 45, 16, 2, 199000);
INSERT INTO `cart_items` VALUES (22, 7, 39, 4, 1, 269000);

-- ----------------------------
-- Table structure for carts
-- ----------------------------
DROP TABLE IF EXISTS `carts`;
CREATE TABLE `carts`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of carts
-- ----------------------------
INSERT INTO `carts` VALUES (1, 2, '2026-03-19 20:15:25');
INSERT INTO `carts` VALUES (2, 3, '2026-03-19 20:32:03');
INSERT INTO `carts` VALUES (3, 4, '2026-03-20 16:08:32');
INSERT INTO `carts` VALUES (4, 5, '2026-03-21 02:26:46');
INSERT INTO `carts` VALUES (5, 6, '2026-03-21 02:41:32');
INSERT INTO `carts` VALUES (6, 7, '2026-03-21 02:56:46');
INSERT INTO `carts` VALUES (7, 8, '2026-03-21 19:52:20');
INSERT INTO `carts` VALUES (8, 9, '2026-04-07 20:08:29');

-- ----------------------------
-- Table structure for categories
-- ----------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` int NULL DEFAULT 1,
  `parent_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_category_parent`(`parent_id` ASC) USING BTREE,
  CONSTRAINT `fk_category_parent` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of categories
-- ----------------------------
INSERT INTO `categories` VALUES (1, 'Áo Nam', 1, 12);
INSERT INTO `categories` VALUES (2, 'Quần Nam', 1, 12);
INSERT INTO `categories` VALUES (3, 'Áo Khoác Nam', 1, 12);
INSERT INTO `categories` VALUES (4, 'Áo Nữ', 1, 13);
INSERT INTO `categories` VALUES (5, 'Quần Nữ', 1, 13);
INSERT INTO `categories` VALUES (6, 'Váy / Đầm Nữ', 1, 13);
INSERT INTO `categories` VALUES (7, 'Áo Khoác Nữ', 1, 13);
INSERT INTO `categories` VALUES (8, 'Phụ kiện Nam', 1, NULL);
INSERT INTO `categories` VALUES (10, 'Phụ kiện Nữ', 1, NULL);
INSERT INTO `categories` VALUES (12, 'Thời trang Nam', 1, NULL);
INSERT INTO `categories` VALUES (13, 'Thời trang Nữ', 1, NULL);
INSERT INTO `categories` VALUES (14, 'Phụ kiện', 1, 8);

-- ----------------------------
-- Table structure for colors
-- ----------------------------
DROP TABLE IF EXISTS `colors`;
CREATE TABLE `colors`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of colors
-- ----------------------------
INSERT INTO `colors` VALUES (1, 'Đen');
INSERT INTO `colors` VALUES (2, 'Trắng');
INSERT INTO `colors` VALUES (3, 'Nâu');
INSERT INTO `colors` VALUES (4, 'Xám');
INSERT INTO `colors` VALUES (5, 'Be');
INSERT INTO `colors` VALUES (6, 'Hồng');
INSERT INTO `colors` VALUES (7, 'Xanh dương');

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of contacts
-- ----------------------------
INSERT INTO `contacts` VALUES (1, 3, 'Trần Thị Minh Thư', 'thutran@gmail.com', '0523875448', '12,22,222,222,2222', 'tôi yêu em', 'New', '2026-03-20 16:44:32');
INSERT INTO `contacts` VALUES (2, NULL, 'Nguyen Van Anh Han', '23130087@st.hcmuaf.edu.vn', '0123456789', 'Nguyễn Thị Lý', 'hàn đẹp trai', 'New', '2026-03-29 11:09:55');

-- ----------------------------
-- Table structure for order_items
-- ----------------------------
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `variant_id` int NOT NULL,
  `size` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `thumbnail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `quantity` int NULL DEFAULT NULL,
  `price` decimal(10, 2) NULL DEFAULT NULL,
  `total` decimal(10, 2) NULL DEFAULT NULL,
  `product_id` int NULL DEFAULT NULL,
  `reviewed` tinyint(1) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `order_id`(`order_id` ASC) USING BTREE,
  INDEX `variant_id`(`variant_id` ASC) USING BTREE,
  INDEX `fk_orderitem_product`(`product_id` ASC) USING BTREE,
  CONSTRAINT `fk_orderitem_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of order_items
-- ----------------------------
INSERT INTO `order_items` VALUES (1, 1, 5, 'M', 'Xám', NULL, 2, 399000.00, 798000.00, NULL, 0);
INSERT INTO `order_items` VALUES (2, 2, 3, 'M', 'Trắng', NULL, 1, 180000.00, 180000.00, NULL, 0);
INSERT INTO `order_items` VALUES (3, 3, 3, 'M', 'Trắng', NULL, 1, 180000.00, 180000.00, NULL, 0);
INSERT INTO `order_items` VALUES (4, 4, 5, 'M', 'Xám', NULL, 2, 399000.00, 798000.00, NULL, 0);
INSERT INTO `order_items` VALUES (5, 5, 4, 'S', 'Nâu', NULL, 1, 399000.00, 399000.00, NULL, 0);
INSERT INTO `order_items` VALUES (6, 6, 5, 'M', 'Xám', NULL, 3, 399000.00, 1197000.00, NULL, 0);
INSERT INTO `order_items` VALUES (7, 7, 1, 'M', 'Đen', NULL, 1, 180000.00, 180000.00, NULL, 0);
INSERT INTO `order_items` VALUES (8, 8, 10, 'M', 'Nâu', NULL, 3, 269000.00, 807000.00, NULL, 0);
INSERT INTO `order_items` VALUES (9, 9, 15, 'M', 'Trắng', NULL, 1, 199000.00, 199000.00, NULL, 0);
INSERT INTO `order_items` VALUES (10, 10, 14, 'M', 'Trắng', NULL, 1, 199000.00, 199000.00, NULL, 0);
INSERT INTO `order_items` VALUES (11, 11, 14, 'M', 'Trắng', NULL, 1, 199000.00, 199000.00, NULL, 0);
INSERT INTO `order_items` VALUES (12, 12, 16, 'M', 'Trắng', NULL, 1, 199000.00, 199000.00, NULL, 0);
INSERT INTO `order_items` VALUES (13, 13, 15, 'M', 'Trắng', NULL, 2, 199000.00, 398000.00, NULL, 0);
INSERT INTO `order_items` VALUES (14, 14, 16, 'S', 'Trắng', NULL, 2, 269000.00, 538000.00, 43, 0);
INSERT INTO `order_items` VALUES (15, 15, 16, 'S', 'Trắng', NULL, 2, 269000.00, 538000.00, 43, 0);
INSERT INTO `order_items` VALUES (16, 16, 16, 'S', 'Trắng', NULL, 2, 269000.00, 538000.00, 43, 0);
INSERT INTO `order_items` VALUES (17, 17, 16, 'S', 'Trắng', NULL, 2, 269000.00, 538000.00, 43, 0);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
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
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (1, 3, 'qưe', '0123456789', 'qưeqw', 'qưeqwe', 798000.00, 0.00, 0.00, 798000.00, 'COD', 'UNPAID', 'PENDING', '2026-03-20 04:41:35');
INSERT INTO `orders` VALUES (2, 3, 'qưeqwe', '0123456789', 'qưeqw', 'qưeqwe', 180000.00, 0.00, 0.00, 180000.00, 'COD', 'UNPAID', 'PENDING', '2026-03-20 04:48:35');
INSERT INTO `orders` VALUES (3, 3, 'qưe', '0123456789', '12,22,222,222,2222', 'á', 180000.00, 0.00, 0.00, 180000.00, 'COD', 'UNPAID', 'SHIPPING', '2026-03-20 04:53:47');
INSERT INTO `orders` VALUES (4, 3, 'qưeqwe', '0123456789', 'qưeqw', 'ưqe', 798000.00, 0.00, 0.00, 798000.00, 'COD', 'UNPAID', 'PENDING', '2026-03-20 04:59:56');
INSERT INTO `orders` VALUES (5, 3, 'qưeqwe', '0123456789', '12,22,222,222,2222', 'ad', 399000.00, 0.00, 0.00, 399000.00, 'COD', 'UNPAID', 'PENDING', '2026-03-20 05:01:13');
INSERT INTO `orders` VALUES (6, 3, 'qưeeqw', '0974123624', '12,22,222,222,2222', 'ewqewqweq', 1197000.00, 0.00, 0.00, 1197000.00, 'COD', 'UNPAID', 'PENDING', '2026-03-20 05:03:49');
INSERT INTO `orders` VALUES (7, 8, 'Nguyễn Văn Anh Hàn', '0123456789', 'Hồ Chí Minh', 'ok', 180000.00, 0.00, 0.00, 180000.00, 'COD', 'UNPAID', 'PENDING', '2026-03-21 19:52:57');
INSERT INTO `orders` VALUES (8, 8, 'Nguyễn Văn Anh Hàn', '0921321323', 'Hồ Chí Minh', '', 807000.00, 0.00, 0.00, 807000.00, 'COD', 'UNPAID', 'PENDING', '2026-03-23 15:15:37');
INSERT INTO `orders` VALUES (9, 8, 'han', '0123456789', 'Nguyễn Thị Lý', 'ok', 199000.00, 0.00, 0.00, 199000.00, 'COD', 'UNPAID', 'PENDING', '2026-03-23 15:28:09');
INSERT INTO `orders` VALUES (10, 8, 'han', '0123456789', 'Nguyễn Thị Lý', '', 199000.00, 0.00, 0.00, 199000.00, 'COD', 'UNPAID', 'PENDING', '2026-03-23 15:31:36');
INSERT INTO `orders` VALUES (11, 8, 'Nguyễn Văn Anh Hàn', '0921321323', 'Hồ Chí Minh', '', 199000.00, 0.00, 0.00, 199000.00, 'COD', 'UNPAID', 'PENDING', '2026-03-23 15:33:44');
INSERT INTO `orders` VALUES (12, 8, 'han', '0123456789', 'Nguyễn Thị Lý', '', 199000.00, 0.00, 0.00, 199000.00, 'COD', 'UNPAID', 'CANCELLED', '2026-03-24 12:00:55');
INSERT INTO `orders` VALUES (13, 8, 'Nguyen Van Anh Han', '0123456789', 'Nguyễn Thị Lý', 'ok', 398000.00, 0.00, 0.00, 398000.00, 'COD', 'UNPAID', 'COMPLETED', '2026-03-27 19:24:48');
INSERT INTO `orders` VALUES (14, 8, 'Nguyen Van Anh Han', '0900142141', 'số 11 lý thái tổ, Thị trấn Cô Tô, Huyện Cô Tô, Tỉnh Quảng Ninh', '', 538000.00, 0.00, 0.00, 538000.00, 'VNPAY', 'PENDING', 'PENDING_PAYMENT', '2026-05-01 16:04:02');
INSERT INTO `orders` VALUES (15, 8, 'Nguyen Van Anh Han', '0900142141', 'số 11 lý thái tổ, Thị trấn Cô Tô, Huyện Cô Tô, Tỉnh Quảng Ninh', '', 538000.00, 0.00, 0.00, 538000.00, 'VNPAY', 'PENDING', 'PENDING_PAYMENT', '2026-05-01 16:13:06');
INSERT INTO `orders` VALUES (16, 8, 'Nguyen Van Anh Han', '0900142141', 'số 11 lý thái tổ, Thị trấn Cô Tô, Huyện Cô Tô, Tỉnh Quảng Ninh', '', 538000.00, 0.00, 0.00, 538000.00, 'VNPAY', 'PENDING', 'PENDING_PAYMENT', '2026-05-01 16:24:39');
INSERT INTO `orders` VALUES (17, 8, 'Nguyen Van Anh Han', '0900142141', 'số 11 lý thái tổ, Thị trấn Cô Tô, Huyện Cô Tô, Tỉnh Quảng Ninh', '', 538000.00, 0.00, 0.00, 538000.00, 'VNPAY', 'PENDING', 'PENDING_PAYMENT', '2026-05-01 17:07:17');

-- ----------------------------
-- Table structure for payment_transactions
-- ----------------------------
DROP TABLE IF EXISTS `payment_transactions`;
CREATE TABLE `payment_transactions`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `provider` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'VNPAY',
  `txn_ref` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `transaction_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `amount` decimal(15, 2) NOT NULL,
  `bank_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `response_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `transaction_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'INITIATED',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_payment_transactions_txn_ref`(`txn_ref` ASC) USING BTREE,
  INDEX `fk_payment_transactions_order`(`order_id` ASC) USING BTREE,
  CONSTRAINT `fk_payment_transactions_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of payment_transactions
-- ----------------------------
INSERT INTO `payment_transactions` VALUES (1, 14, 'VNPAY', 'ORD14_20260501160402', NULL, 538000.00, NULL, NULL, 'INITIATED', '2026-05-01 16:04:02');
INSERT INTO `payment_transactions` VALUES (2, 15, 'VNPAY', 'ORD15_20260501161306', NULL, 538000.00, NULL, NULL, 'INITIATED', '2026-05-01 16:13:06');
INSERT INTO `payment_transactions` VALUES (3, 16, 'VNPAY', 'ORD16_20260501162439', NULL, 538000.00, NULL, NULL, 'INITIATED', '2026-05-01 16:24:39');
INSERT INTO `payment_transactions` VALUES (4, 17, 'VNPAY', 'ORD17_20260501170717', NULL, 538000.00, NULL, NULL, 'INITIATED', '2026-05-01 17:07:17');

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
) ENGINE = InnoDB AUTO_INCREMENT = 350 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of product_images
-- ----------------------------
INSERT INTO `product_images` VALUES (1, 38, 'img/products/NU/AOKHOAC/ao-khoac-nu-that-belt-form-straight/main.jpg', 1);
INSERT INTO `product_images` VALUES (2, 38, 'img/products/NU/AOKHOAC/ao-khoac-nu-that-belt-form-straight/1.jpg', 0);
INSERT INTO `product_images` VALUES (3, 39, 'img/products/NU/AOKIEUNU/SWE EAZY OFF-SHOULDER CROP/main.jpg', 1);
INSERT INTO `product_images` VALUES (4, 39, 'img/products/NU/AOKIEUNU/SWE EAZY OFF-SHOULDER CROP/1.jpg', 0);
INSERT INTO `product_images` VALUES (5, 39, 'img/products/NU/AOKIEUNU/SWE EAZY OFF-SHOULDER CROP/2.jpg', 0);
INSERT INTO `product_images` VALUES (6, 39, 'img/products/NU/AOKIEUNU/SWE EAZY OFF-SHOULDER CROP/3.jpg', 0);
INSERT INTO `product_images` VALUES (7, 40, 'img/products/NU/AOKIEUNU/SWE FLOW TUBE TOP/main.jpg', 1);
INSERT INTO `product_images` VALUES (8, 40, 'img/products/NU/AOKIEUNU/SWE FLOW TUBE TOP/1.jpg', 0);
INSERT INTO `product_images` VALUES (9, 40, 'img/products/NU/AOKIEUNU/SWE FLOW TUBE TOP/2.jpg', 0);
INSERT INTO `product_images` VALUES (10, 41, 'img/products/NU/AOKIEUNU/SWE HONEY EDGE BRA/main.jpg', 1);
INSERT INTO `product_images` VALUES (11, 41, 'img/products/NU/AOKIEUNU/SWE HONEY EDGE BRA/1.jpg', 0);
INSERT INTO `product_images` VALUES (12, 41, 'img/products/NU/AOKIEUNU/SWE HONEY EDGE BRA/2.jpg', 0);
INSERT INTO `product_images` VALUES (13, 42, 'img/products/NU/AOKIEUNU/SWE OG BAND SPORT BRA/main.jpg', 1);
INSERT INTO `product_images` VALUES (14, 42, 'img/products/NU/AOKIEUNU/SWE OG BAND SPORT BRA/1.jpg', 0);
INSERT INTO `product_images` VALUES (15, 42, 'img/products/NU/AOKIEUNU/SWE OG BAND SPORT BRA/2.jpg', 0);
INSERT INTO `product_images` VALUES (16, 42, 'img/products/NU/AOKIEUNU/SWE OG BAND SPORT BRA/3.jpg', 0);
INSERT INTO `product_images` VALUES (17, 43, 'img/products/NU/AOKIEUNU/ao-hai-day-denim-nu-cot-no-form-regular/main.jpg', 1);
INSERT INTO `product_images` VALUES (18, 43, 'img/products/NU/AOKIEUNU/ao-hai-day-denim-nu-cot-no-form-regular/1.jpg', 0);
INSERT INTO `product_images` VALUES (19, 43, 'img/products/NU/AOKIEUNU/ao-hai-day-denim-nu-cot-no-form-regular/2.jpg', 0);
INSERT INTO `product_images` VALUES (20, 44, 'img/products/NU/AOTHUN/HADES INVERTED TEE/main.jpg', 1);
INSERT INTO `product_images` VALUES (21, 44, 'img/products/NU/AOTHUN/HADES INVERTED TEE/1.jpg', 0);
INSERT INTO `product_images` VALUES (22, 44, 'img/products/NU/AOTHUN/HADES INVERTED TEE/2.jpg', 0);
INSERT INTO `product_images` VALUES (23, 44, 'img/products/NU/AOTHUN/HADES INVERTED TEE/3.jpg', 0);
INSERT INTO `product_images` VALUES (24, 45, 'img/products/NU/AOTHUN/HADES NO ENTRY TEE/main.jpg', 1);
INSERT INTO `product_images` VALUES (25, 45, 'img/products/NU/AOTHUN/HADES NO ENTRY TEE/1.jpg', 0);
INSERT INTO `product_images` VALUES (26, 45, 'img/products/NU/AOTHUN/HADES NO ENTRY TEE/2.jpg', 0);
INSERT INTO `product_images` VALUES (27, 45, 'img/products/NU/AOTHUN/HADES NO ENTRY TEE/3.jpg', 0);
INSERT INTO `product_images` VALUES (28, 46, 'img/products/NU/AOTHUN/HADES WHISPER RACERBACK/main.jpg', 1);
INSERT INTO `product_images` VALUES (29, 46, 'img/products/NU/AOTHUN/HADES WHISPER RACERBACK/1.jpg', 0);
INSERT INTO `product_images` VALUES (30, 46, 'img/products/NU/AOTHUN/HADES WHISPER RACERBACK/2.jpg', 0);
INSERT INTO `product_images` VALUES (31, 47, 'img/products/NU/AOTHUN/ao-thun-nu-crop-tay-ngan-co-nhan-metal-form-fitted/main.jpg', 1);
INSERT INTO `product_images` VALUES (32, 47, 'img/products/NU/AOTHUN/ao-thun-nu-crop-tay-ngan-co-nhan-metal-form-fitted/1.jpg', 0);
INSERT INTO `product_images` VALUES (33, 47, 'img/products/NU/AOTHUN/ao-thun-nu-crop-tay-ngan-co-nhan-metal-form-fitted/2.jpg', 0);
INSERT INTO `product_images` VALUES (34, 48, 'img/products/NU/AOTHUN/ao-thun-nu-crop-tay-ngan-cotton-theu-chu-regular/main.jpg', 1);
INSERT INTO `product_images` VALUES (35, 48, 'img/products/NU/AOTHUN/ao-thun-nu-crop-tay-ngan-cotton-theu-chu-regular/1.jpg', 0);
INSERT INTO `product_images` VALUES (36, 48, 'img/products/NU/AOTHUN/ao-thun-nu-crop-tay-ngan-cotton-theu-chu-regular/2.jpg', 0);
INSERT INTO `product_images` VALUES (37, 49, 'img/products/NU/AOTHUN/ao-thun-nu-tay-ngan-100-cotton-phoi-vien-tay-co/main.jpg', 1);
INSERT INTO `product_images` VALUES (38, 49, 'img/products/NU/AOTHUN/ao-thun-nu-tay-ngan-100-cotton-phoi-vien-tay-co/1.jpg', 0);
INSERT INTO `product_images` VALUES (39, 49, 'img/products/NU/AOTHUN/ao-thun-nu-tay-ngan-100-cotton-phoi-vien-tay-co/2.jpg', 0);
INSERT INTO `product_images` VALUES (40, 50, 'img/products/NU/AOTHUN/ao-thun-nu-tay-ngan-cotton-ke-soc-ngang-regular/main.jpg', 1);
INSERT INTO `product_images` VALUES (41, 50, 'img/products/NU/AOTHUN/ao-thun-nu-tay-ngan-cotton-ke-soc-ngang-regular/1.jpg', 0);
INSERT INTO `product_images` VALUES (42, 51, 'img/products/NU/AOTHUN/ao-thun-nu-vai-texture-fitted/main.jpg', 1);
INSERT INTO `product_images` VALUES (43, 51, 'img/products/NU/AOTHUN/ao-thun-nu-vai-texture-fitted/1.jpg', 0);
INSERT INTO `product_images` VALUES (44, 51, 'img/products/NU/AOTHUN/ao-thun-nu-vai-texture-fitted/2.jpg', 0);
INSERT INTO `product_images` VALUES (45, 52, 'img/products/NU/AOTHUN/ao-thun-tam-nu-cuon-beo-tay-dai-form-fitted/main.jpg', 1);
INSERT INTO `product_images` VALUES (46, 52, 'img/products/NU/AOTHUN/ao-thun-tam-nu-cuon-beo-tay-dai-form-fitted/1.jpg', 0);
INSERT INTO `product_images` VALUES (47, 52, 'img/products/NU/AOTHUN/ao-thun-tam-nu-cuon-beo-tay-dai-form-fitted/2.jpg', 0);
INSERT INTO `product_images` VALUES (48, 53, 'img/products/NU/AOTHUN/ao-thun-tay-ngan-nu-hinh-in-fitted/main.jpg', 1);
INSERT INTO `product_images` VALUES (49, 53, 'img/products/NU/AOTHUN/ao-thun-tay-ngan-nu-hinh-in-fitted/1.jpg', 0);
INSERT INTO `product_images` VALUES (50, 53, 'img/products/NU/AOTHUN/ao-thun-tay-ngan-nu-hinh-in-fitted/2.jpg', 0);
INSERT INTO `product_images` VALUES (51, 54, 'img/products/NU/AOTHUN/ao-thun-tay-ngan-nu-soc-co-tron-slim/main.jpg', 1);
INSERT INTO `product_images` VALUES (52, 54, 'img/products/NU/AOTHUN/ao-thun-tay-ngan-nu-soc-co-tron-slim/1.jpg', 0);
INSERT INTO `product_images` VALUES (53, 54, 'img/products/NU/AOTHUN/ao-thun-tay-ngan-nu-soc-co-tron-slim/2.jpg', 0);
INSERT INTO `product_images` VALUES (54, 55, 'img/products/NU/CHANVAY/chan-vay-nu-ban-lung-to-a-line/main.jpg', 1);
INSERT INTO `product_images` VALUES (55, 55, 'img/products/NU/CHANVAY/chan-vay-nu-ban-lung-to-a-line/1.jpg', 0);
INSERT INTO `product_images` VALUES (56, 56, 'img/products/Nam/AOKHOAC/HADES ASTRAL DENIM JACKET/main.jpg', 1);
INSERT INTO `product_images` VALUES (57, 56, 'img/products/Nam/AOKHOAC/HADES ASTRAL DENIM JACKET/1.jpg', 0);
INSERT INTO `product_images` VALUES (58, 56, 'img/products/Nam/AOKHOAC/HADES ASTRAL DENIM JACKET/2.jpg', 0);
INSERT INTO `product_images` VALUES (59, 56, 'img/products/Nam/AOKHOAC/HADES ASTRAL DENIM JACKET/3.jpg', 0);
INSERT INTO `product_images` VALUES (60, 57, 'img/products/Nam/AOKHOAC/HADES ENLISTED ZIP HOODIE/main.jpg', 1);
INSERT INTO `product_images` VALUES (61, 57, 'img/products/Nam/AOKHOAC/HADES ENLISTED ZIP HOODIE/1.jpg', 0);
INSERT INTO `product_images` VALUES (62, 57, 'img/products/Nam/AOKHOAC/HADES ENLISTED ZIP HOODIE/2.jpg', 0);
INSERT INTO `product_images` VALUES (63, 57, 'img/products/Nam/AOKHOAC/HADES ENLISTED ZIP HOODIE/3.jpg', 0);
INSERT INTO `product_images` VALUES (64, 58, 'img/products/Nam/AOKHOAC/HADES INDUSRTRIAL EDGE HOODIE/main.jpg', 1);
INSERT INTO `product_images` VALUES (65, 58, 'img/products/Nam/AOKHOAC/HADES INDUSRTRIAL EDGE HOODIE/1.jpg', 0);
INSERT INTO `product_images` VALUES (66, 58, 'img/products/Nam/AOKHOAC/HADES INDUSRTRIAL EDGE HOODIE/2.jpg', 0);
INSERT INTO `product_images` VALUES (67, 58, 'img/products/Nam/AOKHOAC/HADES INDUSRTRIAL EDGE HOODIE/3.jpg', 0);
INSERT INTO `product_images` VALUES (68, 59, 'img/products/Nam/AOKHOAC/HADES OBSTREPEROUS VARSITY JACKET/main.jpg', 1);
INSERT INTO `product_images` VALUES (69, 59, 'img/products/Nam/AOKHOAC/HADES OBSTREPEROUS VARSITY JACKET/1.jpg', 0);
INSERT INTO `product_images` VALUES (70, 59, 'img/products/Nam/AOKHOAC/HADES OBSTREPEROUS VARSITY JACKET/2.jpg', 0);
INSERT INTO `product_images` VALUES (71, 59, 'img/products/Nam/AOKHOAC/HADES OBSTREPEROUS VARSITY JACKET/3.jpg', 0);
INSERT INTO `product_images` VALUES (72, 60, 'img/products/Nam/AOKHOAC/HADES REIGN VELVET JACKET/main.jpg', 1);
INSERT INTO `product_images` VALUES (73, 60, 'img/products/Nam/AOKHOAC/HADES REIGN VELVET JACKET/1.jpg', 0);
INSERT INTO `product_images` VALUES (74, 60, 'img/products/Nam/AOKHOAC/HADES REIGN VELVET JACKET/2.jpg', 0);
INSERT INTO `product_images` VALUES (75, 60, 'img/products/Nam/AOKHOAC/HADES REIGN VELVET JACKET/3.jpg', 0);
INSERT INTO `product_images` VALUES (76, 61, 'img/products/Nam/AOKHOAC/HADES TACTICAL CAMO JACKET/main.jpg', 1);
INSERT INTO `product_images` VALUES (77, 61, 'img/products/Nam/AOKHOAC/HADES TACTICAL CAMO JACKET/1.jpg', 0);
INSERT INTO `product_images` VALUES (78, 61, 'img/products/Nam/AOKHOAC/HADES TACTICAL CAMO JACKET/2.jpg', 0);
INSERT INTO `product_images` VALUES (79, 62, 'img/products/Nam/AOKHOAC/HADES TRANZIT TRACK JACKET/main.jpg', 1);
INSERT INTO `product_images` VALUES (80, 62, 'img/products/Nam/AOKHOAC/HADES TRANZIT TRACK JACKET/1.jpg', 0);
INSERT INTO `product_images` VALUES (81, 62, 'img/products/Nam/AOKHOAC/HADES TRANZIT TRACK JACKET/2.jpg', 0);
INSERT INTO `product_images` VALUES (82, 62, 'img/products/Nam/AOKHOAC/HADES TRANZIT TRACK JACKET/3.jpg', 0);
INSERT INTO `product_images` VALUES (83, 63, 'img/products/Nam/AOKHOAC/HADES VOID DRIFTER ZIP HOODIE/main.jpg', 1);
INSERT INTO `product_images` VALUES (84, 63, 'img/products/Nam/AOKHOAC/HADES VOID DRIFTER ZIP HOODIE/1.jpg', 0);
INSERT INTO `product_images` VALUES (85, 63, 'img/products/Nam/AOKHOAC/HADES VOID DRIFTER ZIP HOODIE/2.jpg', 0);
INSERT INTO `product_images` VALUES (86, 63, 'img/products/Nam/AOKHOAC/HADES VOID DRIFTER ZIP HOODIE/3.jpg', 0);
INSERT INTO `product_images` VALUES (87, 64, 'img/products/Nam/AOKHOAC/HADES WASHED MATRIX JACKET/main.jpg', 1);
INSERT INTO `product_images` VALUES (88, 64, 'img/products/Nam/AOKHOAC/HADES WASHED MATRIX JACKET/1.jpg', 0);
INSERT INTO `product_images` VALUES (89, 64, 'img/products/Nam/AOKHOAC/HADES WASHED MATRIX JACKET/2.jpg', 0);
INSERT INTO `product_images` VALUES (90, 64, 'img/products/Nam/AOKHOAC/HADES WASHED MATRIX JACKET/3.jpg', 0);
INSERT INTO `product_images` VALUES (91, 65, 'img/products/Nam/AOKHOAC/ao-khoac-aston/main.jpg', 1);
INSERT INTO `product_images` VALUES (92, 65, 'img/products/Nam/AOKHOAC/ao-khoac-aston/1.jpg', 0);
INSERT INTO `product_images` VALUES (93, 66, 'img/products/Nam/AOKHOAC/ao-khoac-nam-jacky/main.jpg', 1);
INSERT INTO `product_images` VALUES (94, 66, 'img/products/Nam/AOKHOAC/ao-khoac-nam-jacky/1.jpg', 0);
INSERT INTO `product_images` VALUES (95, 66, 'img/products/Nam/AOKHOAC/ao-khoac-nam-jacky/2.jpg', 0);
INSERT INTO `product_images` VALUES (96, 67, 'img/products/Nam/AOKHOAC/ao-khoac-orin/main.jpg', 1);
INSERT INTO `product_images` VALUES (97, 67, 'img/products/Nam/AOKHOAC/ao-khoac-orin/1.jpg', 0);
INSERT INTO `product_images` VALUES (98, 68, 'img/products/Nam/AOSOMI/HADES DEAR SHIRT/main.jpg', 1);
INSERT INTO `product_images` VALUES (99, 68, 'img/products/Nam/AOSOMI/HADES DEAR SHIRT/1.jpg', 0);
INSERT INTO `product_images` VALUES (100, 68, 'img/products/Nam/AOSOMI/HADES DEAR SHIRT/2.jpg', 0);
INSERT INTO `product_images` VALUES (101, 68, 'img/products/Nam/AOSOMI/HADES DEAR SHIRT/3.jpg', 0);
INSERT INTO `product_images` VALUES (102, 69, 'img/products/Nam/AOSOMI/HADES FADE OUT WOVEN SHIRT/main.jpg', 1);
INSERT INTO `product_images` VALUES (103, 69, 'img/products/Nam/AOSOMI/HADES FADE OUT WOVEN SHIRT/1.jpg', 0);
INSERT INTO `product_images` VALUES (104, 69, 'img/products/Nam/AOSOMI/HADES FADE OUT WOVEN SHIRT/2.jpg', 0);
INSERT INTO `product_images` VALUES (105, 69, 'img/products/Nam/AOSOMI/HADES FADE OUT WOVEN SHIRT/3.jpg', 0);
INSERT INTO `product_images` VALUES (106, 70, 'img/products/Nam/AOSOMI/HADES SILENT GAZE SHIRT/main.jpg', 1);
INSERT INTO `product_images` VALUES (107, 70, 'img/products/Nam/AOSOMI/HADES SILENT GAZE SHIRT/1.jpg', 0);
INSERT INTO `product_images` VALUES (108, 70, 'img/products/Nam/AOSOMI/HADES SILENT GAZE SHIRT/2.jpg', 0);
INSERT INTO `product_images` VALUES (109, 70, 'img/products/Nam/AOSOMI/HADES SILENT GAZE SHIRT/3.jpg', 0);
INSERT INTO `product_images` VALUES (110, 71, 'img/products/Nam/AOSOMI/HADES THREADLINE SHIRT/main.jpg', 1);
INSERT INTO `product_images` VALUES (111, 71, 'img/products/Nam/AOSOMI/HADES THREADLINE SHIRT/1.jpg', 0);
INSERT INTO `product_images` VALUES (112, 71, 'img/products/Nam/AOSOMI/HADES THREADLINE SHIRT/2.jpg', 0);
INSERT INTO `product_images` VALUES (113, 71, 'img/products/Nam/AOSOMI/HADES THREADLINE SHIRT/3.jpg', 0);
INSERT INTO `product_images` VALUES (114, 72, 'img/products/Nam/AOSOMI/HADES URBAN LINES SHIRT/main.jpg', 1);
INSERT INTO `product_images` VALUES (115, 72, 'img/products/Nam/AOSOMI/HADES URBAN LINES SHIRT/1.jpg', 0);
INSERT INTO `product_images` VALUES (116, 72, 'img/products/Nam/AOSOMI/HADES URBAN LINES SHIRT/2.jpg', 0);
INSERT INTO `product_images` VALUES (117, 72, 'img/products/Nam/AOSOMI/HADES URBAN LINES SHIRT/3.jpg', 0);
INSERT INTO `product_images` VALUES (118, 73, 'img/products/Nam/AOSOMI/ao-so-mi-justin/main.jpg', 1);
INSERT INTO `product_images` VALUES (119, 73, 'img/products/Nam/AOSOMI/ao-so-mi-justin/1.jpg', 0);
INSERT INTO `product_images` VALUES (120, 74, 'img/products/Nam/AOSOMI/ao-so-mi-nam-extra-cotton/main.jpg', 1);
INSERT INTO `product_images` VALUES (121, 74, 'img/products/Nam/AOSOMI/ao-so-mi-nam-extra-cotton/1.jpg', 0);
INSERT INTO `product_images` VALUES (122, 74, 'img/products/Nam/AOSOMI/ao-so-mi-nam-extra-cotton/2.jpg', 0);
INSERT INTO `product_images` VALUES (123, 75, 'img/products/Nam/AOSOMI/ao-so-mi-nam-linen/main.jpg', 1);
INSERT INTO `product_images` VALUES (124, 75, 'img/products/Nam/AOSOMI/ao-so-mi-nam-linen/1.jpg', 0);
INSERT INTO `product_images` VALUES (125, 75, 'img/products/Nam/AOSOMI/ao-so-mi-nam-linen/2.jpg', 0);
INSERT INTO `product_images` VALUES (126, 76, 'img/products/Nam/AOSOMI/ao-so-mi-nam-oxford/main.jpg', 1);
INSERT INTO `product_images` VALUES (127, 76, 'img/products/Nam/AOSOMI/ao-so-mi-nam-oxford/1.jpg', 0);
INSERT INTO `product_images` VALUES (128, 76, 'img/products/Nam/AOSOMI/ao-so-mi-nam-oxford/2.jpg', 0);
INSERT INTO `product_images` VALUES (129, 76, 'img/products/Nam/AOSOMI/ao-so-mi-nam-oxford/3.jpg', 0);
INSERT INTO `product_images` VALUES (130, 77, 'img/products/Nam/AOSOMI/ao-so-mi-nam-ribbed/main.jpg', 1);
INSERT INTO `product_images` VALUES (131, 77, 'img/products/Nam/AOSOMI/ao-so-mi-nam-ribbed/1.jpg', 0);
INSERT INTO `product_images` VALUES (132, 77, 'img/products/Nam/AOSOMI/ao-so-mi-nam-ribbed/2.jpg', 0);
INSERT INTO `product_images` VALUES (133, 78, 'img/products/Nam/AOSOMI/ao-so-mi-nam-tay-ngan-haller/main.jpg', 1);
INSERT INTO `product_images` VALUES (134, 78, 'img/products/Nam/AOSOMI/ao-so-mi-nam-tay-ngan-haller/1.jpg', 0);
INSERT INTO `product_images` VALUES (135, 79, 'img/products/Nam/AOSOMI/ao-so-mi-oxford-premium/main.jpg', 1);
INSERT INTO `product_images` VALUES (136, 79, 'img/products/Nam/AOSOMI/ao-so-mi-oxford-premium/1.jpg', 0);
INSERT INTO `product_images` VALUES (137, 79, 'img/products/Nam/AOSOMI/ao-so-mi-oxford-premium/2.jpg', 0);
INSERT INTO `product_images` VALUES (138, 80, 'img/products/Nam/AOSOMI/ao-so-mi-poplin/main.jpg', 1);
INSERT INTO `product_images` VALUES (139, 80, 'img/products/Nam/AOSOMI/ao-so-mi-poplin/1.jpg', 0);
INSERT INTO `product_images` VALUES (140, 80, 'img/products/Nam/AOSOMI/ao-so-mi-poplin/2.jpg', 0);
INSERT INTO `product_images` VALUES (141, 81, 'img/products/Nam/AOSOMI/ao-so-mi-santo/main.jpg', 1);
INSERT INTO `product_images` VALUES (142, 81, 'img/products/Nam/AOSOMI/ao-so-mi-santo/1.jpg', 0);
INSERT INTO `product_images` VALUES (143, 82, 'img/products/Nam/AOTHUN/HADES 777 JERSEY MESH/main.jpg', 1);
INSERT INTO `product_images` VALUES (144, 82, 'img/products/Nam/AOTHUN/HADES 777 JERSEY MESH/1.jpg', 0);
INSERT INTO `product_images` VALUES (145, 82, 'img/products/Nam/AOTHUN/HADES 777 JERSEY MESH/2.jpg', 0);
INSERT INTO `product_images` VALUES (146, 82, 'img/products/Nam/AOTHUN/HADES 777 JERSEY MESH/3.jpg', 0);
INSERT INTO `product_images` VALUES (147, 83, 'img/products/Nam/AOTHUN/HADES ATHLETE IGNITE JERSEY/main.jpg', 1);
INSERT INTO `product_images` VALUES (148, 83, 'img/products/Nam/AOTHUN/HADES ATHLETE IGNITE JERSEY/1.jpg', 0);
INSERT INTO `product_images` VALUES (149, 83, 'img/products/Nam/AOTHUN/HADES ATHLETE IGNITE JERSEY/2.jpg', 0);
INSERT INTO `product_images` VALUES (150, 83, 'img/products/Nam/AOTHUN/HADES ATHLETE IGNITE JERSEY/3.jpg', 0);
INSERT INTO `product_images` VALUES (151, 84, 'img/products/Nam/AOTHUN/HADES FLUFFY GRILL TEE/main.jpg', 1);
INSERT INTO `product_images` VALUES (152, 84, 'img/products/Nam/AOTHUN/HADES FLUFFY GRILL TEE/1.jpg', 0);
INSERT INTO `product_images` VALUES (153, 84, 'img/products/Nam/AOTHUN/HADES FLUFFY GRILL TEE/2.jpg', 0);
INSERT INTO `product_images` VALUES (154, 84, 'img/products/Nam/AOTHUN/HADES FLUFFY GRILL TEE/3.jpg', 0);
INSERT INTO `product_images` VALUES (155, 85, 'img/products/Nam/AOTHUN/HADES GLORY WASH TEE/main.jpg', 1);
INSERT INTO `product_images` VALUES (156, 85, 'img/products/Nam/AOTHUN/HADES GLORY WASH TEE/1.jpg', 0);
INSERT INTO `product_images` VALUES (157, 85, 'img/products/Nam/AOTHUN/HADES GLORY WASH TEE/2.jpg', 0);
INSERT INTO `product_images` VALUES (158, 85, 'img/products/Nam/AOTHUN/HADES GLORY WASH TEE/3.jpg', 0);
INSERT INTO `product_images` VALUES (159, 86, 'img/products/Nam/AOTHUN/HADES LAST KISS LONGSLEEVE/main.jpg', 1);
INSERT INTO `product_images` VALUES (160, 86, 'img/products/Nam/AOTHUN/HADES LAST KISS LONGSLEEVE/1.jpg', 0);
INSERT INTO `product_images` VALUES (161, 86, 'img/products/Nam/AOTHUN/HADES LAST KISS LONGSLEEVE/2.jpg', 0);
INSERT INTO `product_images` VALUES (162, 86, 'img/products/Nam/AOTHUN/HADES LAST KISS LONGSLEEVE/3.jpg', 0);
INSERT INTO `product_images` VALUES (163, 87, 'img/products/Nam/AOTHUN/HADES LUMINOUS 2K MESH JERSEY/main.jpg', 1);
INSERT INTO `product_images` VALUES (164, 87, 'img/products/Nam/AOTHUN/HADES LUMINOUS 2K MESH JERSEY/1.jpg', 0);
INSERT INTO `product_images` VALUES (165, 87, 'img/products/Nam/AOTHUN/HADES LUMINOUS 2K MESH JERSEY/2.jpg', 0);
INSERT INTO `product_images` VALUES (166, 87, 'img/products/Nam/AOTHUN/HADES LUMINOUS 2K MESH JERSEY/3.jpg', 0);
INSERT INTO `product_images` VALUES (167, 88, 'img/products/Nam/AOTHUN/HADES STAMPED KNITTED TEE/main.jpg', 1);
INSERT INTO `product_images` VALUES (168, 88, 'img/products/Nam/AOTHUN/HADES STAMPED KNITTED TEE/1.jpg', 0);
INSERT INTO `product_images` VALUES (169, 88, 'img/products/Nam/AOTHUN/HADES STAMPED KNITTED TEE/2.jpg', 0);
INSERT INTO `product_images` VALUES (170, 88, 'img/products/Nam/AOTHUN/HADES STAMPED KNITTED TEE/3.jpg', 0);
INSERT INTO `product_images` VALUES (171, 89, 'img/products/Nam/AOTHUN/HADES TROOPER CAMO LONGSLEEVE TEE/main.jpg', 1);
INSERT INTO `product_images` VALUES (172, 89, 'img/products/Nam/AOTHUN/HADES TROOPER CAMO LONGSLEEVE TEE/1.jpg', 0);
INSERT INTO `product_images` VALUES (173, 89, 'img/products/Nam/AOTHUN/HADES TROOPER CAMO LONGSLEEVE TEE/2.jpg', 0);
INSERT INTO `product_images` VALUES (174, 89, 'img/products/Nam/AOTHUN/HADES TROOPER CAMO LONGSLEEVE TEE/3.jpg', 0);
INSERT INTO `product_images` VALUES (175, 90, 'img/products/Nam/AOTHUN/HADES VALOR GRIP TEE/main.jpg', 1);
INSERT INTO `product_images` VALUES (176, 90, 'img/products/Nam/AOTHUN/HADES VALOR GRIP TEE/1.jpg', 0);
INSERT INTO `product_images` VALUES (177, 90, 'img/products/Nam/AOTHUN/HADES VALOR GRIP TEE/2.jpg', 0);
INSERT INTO `product_images` VALUES (178, 90, 'img/products/Nam/AOTHUN/HADES VALOR GRIP TEE/3.jpg', 0);
INSERT INTO `product_images` VALUES (179, 91, 'img/products/Nam/AOTHUN/ao-thun-basic-usa/main.jpg', 1);
INSERT INTO `product_images` VALUES (180, 91, 'img/products/Nam/AOTHUN/ao-thun-basic-usa/1.jpg', 0);
INSERT INTO `product_images` VALUES (181, 91, 'img/products/Nam/AOTHUN/ao-thun-basic-usa/2.jpg', 0);
INSERT INTO `product_images` VALUES (182, 91, 'img/products/Nam/AOTHUN/ao-thun-basic-usa/3.jpg', 0);
INSERT INTO `product_images` VALUES (183, 91, 'img/products/Nam/AOTHUN/ao-thun-basic-usa/4.jpg', 0);
INSERT INTO `product_images` VALUES (184, 92, 'img/products/Nam/AOTHUN/ao-thun-dai-tay-jackson/main.jpg', 1);
INSERT INTO `product_images` VALUES (185, 92, 'img/products/Nam/AOTHUN/ao-thun-dai-tay-jackson/1.jpg', 0);
INSERT INTO `product_images` VALUES (186, 92, 'img/products/Nam/AOTHUN/ao-thun-dai-tay-jackson/2.jpg', 0);
INSERT INTO `product_images` VALUES (187, 92, 'img/products/Nam/AOTHUN/ao-thun-dai-tay-jackson/3.jpg', 0);
INSERT INTO `product_images` VALUES (188, 93, 'img/products/Nam/AOTHUN/ao-thun-galor/main.jpg', 1);
INSERT INTO `product_images` VALUES (189, 93, 'img/products/Nam/AOTHUN/ao-thun-galor/1.jpg', 0);
INSERT INTO `product_images` VALUES (190, 93, 'img/products/Nam/AOTHUN/ao-thun-galor/2.jpg', 0);
INSERT INTO `product_images` VALUES (191, 93, 'img/products/Nam/AOTHUN/ao-thun-galor/3.jpg', 0);
INSERT INTO `product_images` VALUES (192, 93, 'img/products/Nam/AOTHUN/ao-thun-galor/4.jpg', 0);
INSERT INTO `product_images` VALUES (193, 94, 'img/products/Nam/AOTHUN/ao-thun-lio/main.jpg', 1);
INSERT INTO `product_images` VALUES (194, 94, 'img/products/Nam/AOTHUN/ao-thun-lio/1.jpg', 0);
INSERT INTO `product_images` VALUES (195, 94, 'img/products/Nam/AOTHUN/ao-thun-lio/2.jpg', 0);
INSERT INTO `product_images` VALUES (196, 94, 'img/products/Nam/AOTHUN/ao-thun-lio/3.jpg', 0);
INSERT INTO `product_images` VALUES (197, 95, 'img/products/Nam/AOTHUN/ao-thun-mike/main.jpg', 1);
INSERT INTO `product_images` VALUES (198, 95, 'img/products/Nam/AOTHUN/ao-thun-mike/1.jpg', 0);
INSERT INTO `product_images` VALUES (199, 95, 'img/products/Nam/AOTHUN/ao-thun-mike/2.jpg', 0);
INSERT INTO `product_images` VALUES (200, 96, 'img/products/Nam/AOTHUN/ao-thun-nam-horiz-shirt/main.jpg', 1);
INSERT INTO `product_images` VALUES (201, 96, 'img/products/Nam/AOTHUN/ao-thun-nam-horiz-shirt/1.jpg', 0);
INSERT INTO `product_images` VALUES (202, 96, 'img/products/Nam/AOTHUN/ao-thun-nam-horiz-shirt/2.jpg', 0);
INSERT INTO `product_images` VALUES (203, 97, 'img/products/Nam/AOTHUN/ao-thun-nam-vai-knit-jersey/main.jpg', 1);
INSERT INTO `product_images` VALUES (204, 97, 'img/products/Nam/AOTHUN/ao-thun-nam-vai-knit-jersey/1.jpg', 0);
INSERT INTO `product_images` VALUES (205, 97, 'img/products/Nam/AOTHUN/ao-thun-nam-vai-knit-jersey/2.jpg', 0);
INSERT INTO `product_images` VALUES (206, 97, 'img/products/Nam/AOTHUN/ao-thun-nam-vai-knit-jersey/3.jpg', 0);
INSERT INTO `product_images` VALUES (207, 98, 'img/products/Nam/AOTHUN/ao-thun-tank-top/main.jpg', 1);
INSERT INTO `product_images` VALUES (208, 98, 'img/products/Nam/AOTHUN/ao-thun-tank-top/1.jpg', 0);
INSERT INTO `product_images` VALUES (209, 98, 'img/products/Nam/AOTHUN/ao-thun-tank-top/2.jpg', 0);
INSERT INTO `product_images` VALUES (210, 99, 'img/products/Nam/AOTHUN/ao-thun-toby/main.jpg', 1);
INSERT INTO `product_images` VALUES (211, 99, 'img/products/Nam/AOTHUN/ao-thun-toby/1.jpg', 0);
INSERT INTO `product_images` VALUES (212, 99, 'img/products/Nam/AOTHUN/ao-thun-toby/2.jpg', 0);
INSERT INTO `product_images` VALUES (213, 100, 'img/products/Nam/QUANJEAN/HADES DISSENT TROUSERS PANTS/main.jpg', 1);
INSERT INTO `product_images` VALUES (214, 100, 'img/products/Nam/QUANJEAN/HADES DISSENT TROUSERS PANTS/1.jpg', 0);
INSERT INTO `product_images` VALUES (215, 100, 'img/products/Nam/QUANJEAN/HADES DISSENT TROUSERS PANTS/2.jpg', 0);
INSERT INTO `product_images` VALUES (216, 100, 'img/products/Nam/QUANJEAN/HADES DISSENT TROUSERS PANTS/3.jpg', 0);
INSERT INTO `product_images` VALUES (217, 101, 'img/products/Nam/QUANJEAN/HADES DUNE RUPTUNE WASH JEANS/main.jpg', 1);
INSERT INTO `product_images` VALUES (218, 101, 'img/products/Nam/QUANJEAN/HADES DUNE RUPTUNE WASH JEANS/1.jpg', 0);
INSERT INTO `product_images` VALUES (219, 101, 'img/products/Nam/QUANJEAN/HADES DUNE RUPTUNE WASH JEANS/2.jpg', 0);
INSERT INTO `product_images` VALUES (220, 101, 'img/products/Nam/QUANJEAN/HADES DUNE RUPTUNE WASH JEANS/3.jpg', 0);
INSERT INTO `product_images` VALUES (221, 102, 'img/products/Nam/QUANJEAN/HADES PINK STARDUST PANTS/main.jpg', 1);
INSERT INTO `product_images` VALUES (222, 102, 'img/products/Nam/QUANJEAN/HADES PINK STARDUST PANTS/1.jpg', 0);
INSERT INTO `product_images` VALUES (223, 102, 'img/products/Nam/QUANJEAN/HADES PINK STARDUST PANTS/2.jpg', 0);
INSERT INTO `product_images` VALUES (224, 102, 'img/products/Nam/QUANJEAN/HADES PINK STARDUST PANTS/3.jpg', 0);
INSERT INTO `product_images` VALUES (225, 103, 'img/products/Nam/QUANJEAN/HADES REPEAT SCRIPT LOOSEFIT JEANS/main.jpg', 1);
INSERT INTO `product_images` VALUES (226, 103, 'img/products/Nam/QUANJEAN/HADES REPEAT SCRIPT LOOSEFIT JEANS/1.jpg', 0);
INSERT INTO `product_images` VALUES (227, 103, 'img/products/Nam/QUANJEAN/HADES REPEAT SCRIPT LOOSEFIT JEANS/2.jpg', 0);
INSERT INTO `product_images` VALUES (228, 103, 'img/products/Nam/QUANJEAN/HADES REPEAT SCRIPT LOOSEFIT JEANS/3.jpg', 0);
INSERT INTO `product_images` VALUES (229, 104, 'img/products/Nam/QUANJEAN/HADES WASH BAGGY DENIM TROUSERS/main.jpg', 1);
INSERT INTO `product_images` VALUES (230, 104, 'img/products/Nam/QUANJEAN/HADES WASH BAGGY DENIM TROUSERS/1.jpg', 0);
INSERT INTO `product_images` VALUES (231, 104, 'img/products/Nam/QUANJEAN/HADES WASH BAGGY DENIM TROUSERS/2.jpg', 0);
INSERT INTO `product_images` VALUES (232, 104, 'img/products/Nam/QUANJEAN/HADES WASH BAGGY DENIM TROUSERS/3.jpg', 0);
INSERT INTO `product_images` VALUES (233, 105, 'img/products/Nam/QUANJEAN/HADES WRECKAGE JEANS/main.jpg', 1);
INSERT INTO `product_images` VALUES (234, 105, 'img/products/Nam/QUANJEAN/HADES WRECKAGE JEANS/2..jpg', 0);
INSERT INTO `product_images` VALUES (235, 105, 'img/products/Nam/QUANJEAN/HADES WRECKAGE JEANS/3.jpg', 0);
INSERT INTO `product_images` VALUES (236, 106, 'img/products/Nam/QUANJEAN/quan-denim-nam-balloon/main.jpg', 1);
INSERT INTO `product_images` VALUES (237, 106, 'img/products/Nam/QUANJEAN/quan-denim-nam-balloon/1.jpg', 0);
INSERT INTO `product_images` VALUES (238, 106, 'img/products/Nam/QUANJEAN/quan-denim-nam-balloon/2.jpg', 0);
INSERT INTO `product_images` VALUES (239, 107, 'img/products/Nam/QUANJEAN/quan-denim-nam-cocoon/main.jpg', 1);
INSERT INTO `product_images` VALUES (240, 107, 'img/products/Nam/QUANJEAN/quan-denim-nam-cocoon/1.jpg', 0);
INSERT INTO `product_images` VALUES (241, 107, 'img/products/Nam/QUANJEAN/quan-denim-nam-cocoon/2.jpg', 0);
INSERT INTO `product_images` VALUES (242, 107, 'img/products/Nam/QUANJEAN/quan-denim-nam-cocoon/3.jpg', 0);
INSERT INTO `product_images` VALUES (243, 108, 'img/products/Nam/QUANJEAN/quan-denim-nam-gap-ong-form-straight-crop/main.jpg', 1);
INSERT INTO `product_images` VALUES (244, 108, 'img/products/Nam/QUANJEAN/quan-denim-nam-gap-ong-form-straight-crop/1.jpg', 0);
INSERT INTO `product_images` VALUES (245, 108, 'img/products/Nam/QUANJEAN/quan-denim-nam-gap-ong-form-straight-crop/2.jpg', 0);
INSERT INTO `product_images` VALUES (246, 108, 'img/products/Nam/QUANJEAN/quan-denim-nam-gap-ong-form-straight-crop/3.jpg', 0);
INSERT INTO `product_images` VALUES (247, 109, 'img/products/Nam/QUANJEAN/quan-denim-nam-ong-rong-rui-suon-form-loose/main.jpg', 1);
INSERT INTO `product_images` VALUES (248, 109, 'img/products/Nam/QUANJEAN/quan-denim-nam-ong-rong-rui-suon-form-loose/1.jpg', 0);
INSERT INTO `product_images` VALUES (249, 109, 'img/products/Nam/QUANJEAN/quan-denim-nam-ong-rong-rui-suon-form-loose/2.jpg', 0);
INSERT INTO `product_images` VALUES (250, 109, 'img/products/Nam/QUANJEAN/quan-denim-nam-ong-rong-rui-suon-form-loose/3.jpg', 0);
INSERT INTO `product_images` VALUES (251, 110, 'img/products/Nam/QUANJEAN/quan-denim-nam-tapered/main.jpg', 1);
INSERT INTO `product_images` VALUES (252, 110, 'img/products/Nam/QUANJEAN/quan-denim-nam-tapered/1.jpg', 0);
INSERT INTO `product_images` VALUES (253, 110, 'img/products/Nam/QUANJEAN/quan-denim-nam-tapered/2.jpg', 0);
INSERT INTO `product_images` VALUES (254, 110, 'img/products/Nam/QUANJEAN/quan-denim-nam-tapered/3.jpg', 0);
INSERT INTO `product_images` VALUES (255, 111, 'img/products/Nam/QUANJEAN/quan-denim-nam-wide-leg/main.jpg', 1);
INSERT INTO `product_images` VALUES (256, 111, 'img/products/Nam/QUANJEAN/quan-denim-nam-wide-leg/1.jpg', 0);
INSERT INTO `product_images` VALUES (257, 111, 'img/products/Nam/QUANJEAN/quan-denim-nam-wide-leg/2.jpg', 0);
INSERT INTO `product_images` VALUES (258, 111, 'img/products/Nam/QUANJEAN/quan-denim-nam-wide-leg/3.jpg', 0);
INSERT INTO `product_images` VALUES (259, 112, 'img/products/Nam/QUANJEAN/quan-denim-nam-xep-li-barrel/main.jpg', 1);
INSERT INTO `product_images` VALUES (260, 112, 'img/products/Nam/QUANJEAN/quan-denim-nam-xep-li-barrel/1.jpg', 0);
INSERT INTO `product_images` VALUES (261, 112, 'img/products/Nam/QUANJEAN/quan-denim-nam-xep-li-barrel/2.jpg', 0);
INSERT INTO `product_images` VALUES (262, 113, 'img/products/Nam/QUANJEAN/quan-jeans-nam-den-basic-musthave-slim-cropped/main.jpg', 1);
INSERT INTO `product_images` VALUES (263, 113, 'img/products/Nam/QUANJEAN/quan-jeans-nam-den-basic-musthave-slim-cropped/1.jpg', 0);
INSERT INTO `product_images` VALUES (264, 113, 'img/products/Nam/QUANJEAN/quan-jeans-nam-den-basic-musthave-slim-cropped/2.jpg', 0);
INSERT INTO `product_images` VALUES (265, 114, 'img/products/Nam/QUANJEAN/quan-jeans-nam-navy-tron-dang-om-slim/main.jpg', 1);
INSERT INTO `product_images` VALUES (266, 114, 'img/products/Nam/QUANJEAN/quan-jeans-nam-navy-tron-dang-om-slim/1.jpg', 0);
INSERT INTO `product_images` VALUES (267, 114, 'img/products/Nam/QUANJEAN/quan-jeans-nam-navy-tron-dang-om-slim/2.jpg', 0);
INSERT INTO `product_images` VALUES (268, 114, 'img/products/Nam/QUANJEAN/quan-jeans-nam-navy-tron-dang-om-slim/3.jpg', 0);
INSERT INTO `product_images` VALUES (269, 115, 'img/products/Nam/QUANSHORT/HADES CAMO MESH SHORT - WHITE/main.jpg', 1);
INSERT INTO `product_images` VALUES (270, 115, 'img/products/Nam/QUANSHORT/HADES CAMO MESH SHORT - WHITE/1.jpg', 0);
INSERT INTO `product_images` VALUES (271, 115, 'img/products/Nam/QUANSHORT/HADES CAMO MESH SHORT - WHITE/2.jpg', 0);
INSERT INTO `product_images` VALUES (272, 115, 'img/products/Nam/QUANSHORT/HADES CAMO MESH SHORT - WHITE/3.jpg', 0);
INSERT INTO `product_images` VALUES (273, 116, 'img/products/Nam/QUANSHORT/quan-short-denim-nam-form-straight/main.jpg', 1);
INSERT INTO `product_images` VALUES (274, 116, 'img/products/Nam/QUANSHORT/quan-short-denim-nam-form-straight/1.jpg', 0);
INSERT INTO `product_images` VALUES (275, 117, 'img/products/Nam/QUANSHORT/quan-short-nam-cotton-spandex-dieu-gan-form-loose/main.jpg', 1);
INSERT INTO `product_images` VALUES (276, 117, 'img/products/Nam/QUANSHORT/quan-short-nam-cotton-spandex-dieu-gan-form-loose/1.jpg', 0);
INSERT INTO `product_images` VALUES (277, 118, 'img/products/Nam/QUANSHORT/quan-short-nam-double-face-form-relax/main.jpg', 1);
INSERT INTO `product_images` VALUES (278, 118, 'img/products/Nam/QUANSHORT/quan-short-nam-double-face-form-relax/1.jpg', 0);
INSERT INTO `product_images` VALUES (279, 119, 'img/products/Nam/QUANSHORT/quan-short-nam-hoa-tiet-cotton-lung-thun/main.jpg', 1);
INSERT INTO `product_images` VALUES (280, 119, 'img/products/Nam/QUANSHORT/quan-short-nam-hoa-tiet-cotton-lung-thun/1.jpg', 0);
INSERT INTO `product_images` VALUES (281, 120, 'img/products/Nam/QUANSHORT/quan-short-nam-kieu-tron-form-straight/main.jpg', 1);
INSERT INTO `product_images` VALUES (282, 120, 'img/products/Nam/QUANSHORT/quan-short-nam-kieu-tron-form-straight/1.jpg', 0);
INSERT INTO `product_images` VALUES (283, 120, 'img/products/Nam/QUANSHORT/quan-short-nam-kieu-tron-form-straight/2.jpg', 0);
INSERT INTO `product_images` VALUES (284, 121, 'img/products/Nam/QUANSHORT/quan-short-nam-nylon-vai-du-tui-dap-relax/main.jpg', 1);
INSERT INTO `product_images` VALUES (285, 121, 'img/products/Nam/QUANSHORT/quan-short-nam-nylon-vai-du-tui-dap-relax/1.jpg', 0);
INSERT INTO `product_images` VALUES (286, 122, 'img/products/Nam/QUANSHORT/quan-short-nam-premium-straight/main.jpg', 1);
INSERT INTO `product_images` VALUES (287, 122, 'img/products/Nam/QUANSHORT/quan-short-nam-premium-straight/1.jpg', 0);
INSERT INTO `product_images` VALUES (288, 122, 'img/products/Nam/QUANSHORT/quan-short-nam-premium-straight/2.jpg', 0);
INSERT INTO `product_images` VALUES (289, 123, 'img/products/Nam/QUANSHORT/quan-short-nam-vai-du-tui-dap-form-relax/main.jpg', 1);
INSERT INTO `product_images` VALUES (290, 123, 'img/products/Nam/QUANSHORT/quan-short-nam-vai-du-tui-dap-form-relax/1.jpg', 0);
INSERT INTO `product_images` VALUES (291, 124, 'img/products/Nam/QUANTAY/quan-tay-dai-nam-slim/main.jpg', 1);
INSERT INTO `product_images` VALUES (292, 124, 'img/products/Nam/QUANTAY/quan-tay-dai-nam-slim/1.jpg', 0);
INSERT INTO `product_images` VALUES (293, 124, 'img/products/Nam/QUANTAY/quan-tay-dai-nam-slim/2.jpg', 0);
INSERT INTO `product_images` VALUES (294, 125, 'img/products/Nam/QUANTAY/quan-tay-dai-nam-slim-cropped/main.jpg', 1);
INSERT INTO `product_images` VALUES (295, 125, 'img/products/Nam/QUANTAY/quan-tay-dai-nam-slim-cropped/1.jpg', 0);
INSERT INTO `product_images` VALUES (296, 126, 'img/products/Nam/QUANTAY/quan-tay-nam-dai-chat-lieu-kaki-form-slim/main.jpg', 1);
INSERT INTO `product_images` VALUES (297, 126, 'img/products/Nam/QUANTAY/quan-tay-nam-dai-chat-lieu-kaki-form-slim/1.jpg', 0);
INSERT INTO `product_images` VALUES (298, 126, 'img/products/Nam/QUANTAY/quan-tay-nam-dai-chat-lieu-kaki-form-slim/2.jpg', 0);
INSERT INTO `product_images` VALUES (299, 127, 'img/products/Nam/QUANTAY/quan-tay-nam-dai-lung-chun-dieu-chinh-form-slim/main.jpg', 1);
INSERT INTO `product_images` VALUES (300, 127, 'img/products/Nam/QUANTAY/quan-tay-nam-dai-lung-chun-dieu-chinh-form-slim/1.jpg', 0);
INSERT INTO `product_images` VALUES (301, 127, 'img/products/Nam/QUANTAY/quan-tay-nam-dai-lung-chun-dieu-chinh-form-slim/2.jpg', 0);
INSERT INTO `product_images` VALUES (302, 128, 'img/products/Nam/QUANTAY/quan-tay-nam-dai-ui-ly-truoc-form-slim/main.jpg', 1);
INSERT INTO `product_images` VALUES (303, 128, 'img/products/Nam/QUANTAY/quan-tay-nam-dai-ui-ly-truoc-form-slim/1.jpg', 0);
INSERT INTO `product_images` VALUES (304, 129, 'img/products/Nam/QUANTAY/quan-vai-nam-dai-ong-om-form-slim/main.jpg', 1);
INSERT INTO `product_images` VALUES (305, 129, 'img/products/Nam/QUANTAY/quan-vai-nam-dai-ong-om-form-slim/1.jpg', 0);
INSERT INTO `product_images` VALUES (306, 129, 'img/products/Nam/QUANTAY/quan-vai-nam-dai-ong-om-form-slim/2.jpg', 0);
INSERT INTO `product_images` VALUES (307, 130, 'img/products/PHUKIEN/BAG/HADES BACKPACK LEATHER 24/main.jpg', 1);
INSERT INTO `product_images` VALUES (308, 130, 'img/products/PHUKIEN/BAG/HADES BACKPACK LEATHER 24/1.jpg', 0);
INSERT INTO `product_images` VALUES (309, 130, 'img/products/PHUKIEN/BAG/HADES BACKPACK LEATHER 24/2.jpg', 0);
INSERT INTO `product_images` VALUES (310, 130, 'img/products/PHUKIEN/BAG/HADES BACKPACK LEATHER 24/3.jpg', 0);
INSERT INTO `product_images` VALUES (311, 131, 'img/products/PHUKIEN/BAG/HADES NOMAD BACKPACK/main.jpg', 1);
INSERT INTO `product_images` VALUES (312, 131, 'img/products/PHUKIEN/BAG/HADES NOMAD BACKPACK/1.jpg', 0);
INSERT INTO `product_images` VALUES (313, 131, 'img/products/PHUKIEN/BAG/HADES NOMAD BACKPACK/2.jpg', 0);
INSERT INTO `product_images` VALUES (314, 131, 'img/products/PHUKIEN/BAG/HADES NOMAD BACKPACK/3.jpg', 0);
INSERT INTO `product_images` VALUES (315, 132, 'img/products/PHUKIEN/BAG/HADES OBSIDIAN LEATHER BAG/main.jpg', 1);
INSERT INTO `product_images` VALUES (316, 132, 'img/products/PHUKIEN/BAG/HADES OBSIDIAN LEATHER BAG/1.jpg', 0);
INSERT INTO `product_images` VALUES (317, 132, 'img/products/PHUKIEN/BAG/HADES OBSIDIAN LEATHER BAG/2.jpg', 0);
INSERT INTO `product_images` VALUES (318, 132, 'img/products/PHUKIEN/BAG/HADES OBSIDIAN LEATHER BAG/3.jpg', 0);
INSERT INTO `product_images` VALUES (319, 133, 'img/products/PHUKIEN/BAG/HADES QUILTED ARMOR BACKPACK/main.jpg', 1);
INSERT INTO `product_images` VALUES (320, 133, 'img/products/PHUKIEN/BAG/HADES QUILTED ARMOR BACKPACK/1.jpg', 0);
INSERT INTO `product_images` VALUES (321, 133, 'img/products/PHUKIEN/BAG/HADES QUILTED ARMOR BACKPACK/2.jpg', 0);
INSERT INTO `product_images` VALUES (322, 133, 'img/products/PHUKIEN/BAG/HADES QUILTED ARMOR BACKPACK/3.jpg', 0);
INSERT INTO `product_images` VALUES (323, 134, 'img/products/PHUKIEN/BAG/HADES VOYAGER BACKPACK/main.jpg', 1);
INSERT INTO `product_images` VALUES (324, 134, 'img/products/PHUKIEN/BAG/HADES VOYAGER BACKPACK/1.jpg', 0);
INSERT INTO `product_images` VALUES (325, 134, 'img/products/PHUKIEN/BAG/HADES VOYAGER BACKPACK/2.jpg', 0);
INSERT INTO `product_images` VALUES (326, 134, 'img/products/PHUKIEN/BAG/HADES VOYAGER BACKPACK/3.jpg', 0);
INSERT INTO `product_images` VALUES (327, 135, 'img/products/PHUKIEN/KHAN/HADES CLOUD NINE SCARF/main.jpg', 1);
INSERT INTO `product_images` VALUES (328, 135, 'img/products/PHUKIEN/KHAN/HADES CLOUD NINE SCARF/1.jpg', 0);
INSERT INTO `product_images` VALUES (329, 135, 'img/products/PHUKIEN/KHAN/HADES CLOUD NINE SCARF/2.jpg', 0);
INSERT INTO `product_images` VALUES (330, 135, 'img/products/PHUKIEN/KHAN/HADES CLOUD NINE SCARF/3.jpg', 0);
INSERT INTO `product_images` VALUES (331, 136, 'img/products/PHUKIEN/NON/HADES CREST DAD CAP/main.jpg', 1);
INSERT INTO `product_images` VALUES (332, 136, 'img/products/PHUKIEN/NON/HADES CREST DAD CAP/1.jpg', 0);
INSERT INTO `product_images` VALUES (333, 136, 'img/products/PHUKIEN/NON/HADES CREST DAD CAP/2.jpg', 0);
INSERT INTO `product_images` VALUES (334, 136, 'img/products/PHUKIEN/NON/HADES CREST DAD CAP/3.jpg', 0);
INSERT INTO `product_images` VALUES (335, 137, 'img/products/PHUKIEN/NON/HADES DENIM CAMP CAP/main.jpg', 1);
INSERT INTO `product_images` VALUES (336, 137, 'img/products/PHUKIEN/NON/HADES DENIM CAMP CAP/1.jpg', 0);
INSERT INTO `product_images` VALUES (337, 137, 'img/products/PHUKIEN/NON/HADES DENIM CAMP CAP/2.jpg', 0);
INSERT INTO `product_images` VALUES (338, 138, 'img/products/PHUKIEN/NON/HADES DISTRESSED DENIM CAP/main.jpg', 1);
INSERT INTO `product_images` VALUES (339, 138, 'img/products/PHUKIEN/NON/HADES DISTRESSED DENIM CAP/1.jpg', 0);
INSERT INTO `product_images` VALUES (340, 138, 'img/products/PHUKIEN/NON/HADES DISTRESSED DENIM CAP/2.jpg', 0);
INSERT INTO `product_images` VALUES (341, 139, 'img/products/PHUKIEN/NON/HADES DISTRICT 1 CAP/main.jpg', 1);
INSERT INTO `product_images` VALUES (342, 139, 'img/products/PHUKIEN/NON/HADES DISTRICT 1 CAP/1.jpg', 0);
INSERT INTO `product_images` VALUES (343, 139, 'img/products/PHUKIEN/NON/HADES DISTRICT 1 CAP/2.jpg', 0);
INSERT INTO `product_images` VALUES (344, 140, 'img/products/PHUKIEN/NON/HADES ICONIC STAR SNAPBACK/main.jpg', 1);
INSERT INTO `product_images` VALUES (345, 140, 'img/products/PHUKIEN/NON/HADES ICONIC STAR SNAPBACK/1.jpg', 0);
INSERT INTO `product_images` VALUES (346, 140, 'img/products/PHUKIEN/NON/HADES ICONIC STAR SNAPBACK/2.jpg', 0);
INSERT INTO `product_images` VALUES (347, 140, 'img/products/PHUKIEN/NON/HADES ICONIC STAR SNAPBACK/3.jpg', 0);
INSERT INTO `product_images` VALUES (348, 141, 'img/products/PHUKIEN/NON/non-luoi-trai-soi-chuoi-freesize/main.jpg', 1);
INSERT INTO `product_images` VALUES (349, 141, 'img/products/PHUKIEN/NON/non-luoi-trai-soi-chuoi-freesize/1.jpg', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 393 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of product_variants
-- ----------------------------
INSERT INTO `product_variants` VALUES (1, 38, 1, 5, 100, 550000.00, 499000.00);
INSERT INTO `product_variants` VALUES (2, 38, 2, 5, 100, 550000.00, 499000.00);
INSERT INTO `product_variants` VALUES (3, 38, 3, 5, 100, 550000.00, 499000.00);
INSERT INTO `product_variants` VALUES (4, 39, 1, 2, 100, 320000.00, 269000.00);
INSERT INTO `product_variants` VALUES (5, 39, 2, 2, 100, 320000.00, 269000.00);
INSERT INTO `product_variants` VALUES (6, 39, 3, 2, 100, 320000.00, 269000.00);
INSERT INTO `product_variants` VALUES (7, 40, 1, 2, 100, 290000.00, 249000.00);
INSERT INTO `product_variants` VALUES (8, 40, 2, 2, 100, 290000.00, 249000.00);
INSERT INTO `product_variants` VALUES (9, 40, 3, 2, 100, 290000.00, 249000.00);
INSERT INTO `product_variants` VALUES (10, 41, 1, 2, 100, 290000.00, 249000.00);
INSERT INTO `product_variants` VALUES (11, 41, 2, 2, 100, 290000.00, 249000.00);
INSERT INTO `product_variants` VALUES (12, 41, 3, 2, 100, 290000.00, 249000.00);
INSERT INTO `product_variants` VALUES (13, 42, 1, 2, 100, 290000.00, 249000.00);
INSERT INTO `product_variants` VALUES (14, 42, 2, 2, 100, 290000.00, 249000.00);
INSERT INTO `product_variants` VALUES (15, 42, 3, 2, 100, 290000.00, 249000.00);
INSERT INTO `product_variants` VALUES (16, 43, 1, 2, 100, 320000.00, 269000.00);
INSERT INTO `product_variants` VALUES (17, 43, 2, 2, 100, 320000.00, 269000.00);
INSERT INTO `product_variants` VALUES (18, 43, 3, 2, 100, 320000.00, 269000.00);
INSERT INTO `product_variants` VALUES (19, 44, 1, 2, 100, 350000.00, 299000.00);
INSERT INTO `product_variants` VALUES (20, 44, 2, 2, 100, 350000.00, 299000.00);
INSERT INTO `product_variants` VALUES (21, 44, 3, 2, 100, 350000.00, 299000.00);
INSERT INTO `product_variants` VALUES (22, 45, 1, 2, 100, 350000.00, 299000.00);
INSERT INTO `product_variants` VALUES (23, 45, 2, 2, 100, 350000.00, 299000.00);
INSERT INTO `product_variants` VALUES (24, 45, 3, 2, 100, 350000.00, 299000.00);
INSERT INTO `product_variants` VALUES (25, 46, 1, 2, 100, 350000.00, 299000.00);
INSERT INTO `product_variants` VALUES (26, 46, 2, 2, 100, 350000.00, 299000.00);
INSERT INTO `product_variants` VALUES (27, 46, 3, 2, 100, 350000.00, 299000.00);
INSERT INTO `product_variants` VALUES (28, 47, 1, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (29, 47, 2, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (30, 47, 3, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (31, 48, 1, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (32, 48, 2, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (33, 48, 3, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (34, 49, 1, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (35, 49, 2, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (36, 49, 3, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (37, 50, 1, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (38, 50, 2, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (39, 50, 3, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (40, 51, 1, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (41, 51, 2, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (42, 51, 3, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (43, 52, 1, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (44, 52, 2, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (45, 52, 3, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (46, 53, 1, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (47, 53, 2, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (48, 53, 3, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (49, 54, 1, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (50, 54, 2, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (51, 54, 3, 2, 100, 240000.00, 199000.00);
INSERT INTO `product_variants` VALUES (52, 55, 1, 6, 100, 340000.00, 289000.00);
INSERT INTO `product_variants` VALUES (53, 55, 2, 6, 100, 340000.00, 289000.00);
INSERT INTO `product_variants` VALUES (54, 55, 3, 6, 100, 340000.00, 289000.00);
INSERT INTO `product_variants` VALUES (55, 56, 1, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (56, 56, 2, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (57, 56, 3, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (58, 56, 4, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (59, 57, 1, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (60, 57, 2, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (61, 57, 3, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (62, 57, 4, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (63, 58, 1, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (64, 58, 2, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (65, 58, 3, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (66, 58, 4, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (67, 59, 1, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (68, 59, 2, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (69, 59, 3, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (70, 59, 4, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (71, 60, 1, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (72, 60, 2, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (73, 60, 3, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (74, 60, 4, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (75, 61, 1, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (76, 61, 2, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (77, 61, 3, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (78, 61, 4, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (79, 62, 1, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (80, 62, 2, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (81, 62, 3, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (82, 62, 4, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (83, 63, 1, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (84, 63, 2, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (85, 63, 3, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (86, 63, 4, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (87, 64, 1, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (88, 64, 2, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (89, 64, 3, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (90, 64, 4, 1, 100, 890000.00, 799000.00);
INSERT INTO `product_variants` VALUES (91, 65, 1, 5, 100, 550000.00, 499000.00);
INSERT INTO `product_variants` VALUES (92, 65, 2, 5, 100, 550000.00, 499000.00);
INSERT INTO `product_variants` VALUES (93, 65, 3, 5, 100, 550000.00, 499000.00);
INSERT INTO `product_variants` VALUES (94, 65, 4, 5, 100, 550000.00, 499000.00);
INSERT INTO `product_variants` VALUES (95, 66, 1, 5, 100, 550000.00, 499000.00);
INSERT INTO `product_variants` VALUES (96, 66, 2, 5, 100, 550000.00, 499000.00);
INSERT INTO `product_variants` VALUES (97, 66, 3, 5, 100, 550000.00, 499000.00);
INSERT INTO `product_variants` VALUES (98, 66, 4, 5, 100, 550000.00, 499000.00);
INSERT INTO `product_variants` VALUES (99, 67, 1, 5, 100, 550000.00, 499000.00);
INSERT INTO `product_variants` VALUES (100, 67, 2, 5, 100, 550000.00, 499000.00);
INSERT INTO `product_variants` VALUES (101, 67, 3, 5, 100, 550000.00, 499000.00);
INSERT INTO `product_variants` VALUES (102, 67, 4, 5, 100, 550000.00, 499000.00);
INSERT INTO `product_variants` VALUES (103, 68, 1, 2, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (104, 68, 2, 2, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (105, 68, 3, 2, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (106, 68, 4, 2, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (107, 69, 1, 2, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (108, 69, 2, 2, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (109, 69, 3, 2, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (110, 69, 4, 2, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (111, 70, 1, 2, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (112, 70, 2, 2, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (113, 70, 3, 2, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (114, 70, 4, 2, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (115, 71, 1, 2, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (116, 71, 2, 2, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (117, 71, 3, 2, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (118, 71, 4, 2, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (119, 72, 1, 2, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (120, 72, 2, 2, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (121, 72, 3, 2, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (122, 72, 4, 2, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (123, 73, 1, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (124, 73, 2, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (125, 73, 3, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (126, 73, 4, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (127, 74, 1, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (128, 74, 2, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (129, 74, 3, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (130, 74, 4, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (131, 75, 1, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (132, 75, 2, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (133, 75, 3, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (134, 75, 4, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (135, 76, 1, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (136, 76, 2, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (137, 76, 3, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (138, 76, 4, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (139, 77, 1, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (140, 77, 2, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (141, 77, 3, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (142, 77, 4, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (143, 78, 1, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (144, 78, 2, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (145, 78, 3, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (146, 78, 4, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (147, 79, 1, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (148, 79, 2, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (149, 79, 3, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (150, 79, 4, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (151, 80, 1, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (152, 80, 2, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (153, 80, 3, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (154, 80, 4, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (155, 81, 1, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (156, 81, 2, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (157, 81, 3, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (158, 81, 4, 2, 100, 390000.00, 329000.00);
INSERT INTO `product_variants` VALUES (159, 82, 1, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (160, 82, 2, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (161, 82, 3, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (162, 82, 4, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (163, 83, 1, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (164, 83, 2, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (165, 83, 3, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (166, 83, 4, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (167, 84, 1, 1, 100, 350000.00, 299000.00);
INSERT INTO `product_variants` VALUES (168, 84, 2, 1, 100, 350000.00, 299000.00);
INSERT INTO `product_variants` VALUES (169, 84, 3, 1, 100, 350000.00, 299000.00);
INSERT INTO `product_variants` VALUES (170, 84, 4, 1, 100, 350000.00, 299000.00);
INSERT INTO `product_variants` VALUES (171, 85, 1, 1, 100, 350000.00, 299000.00);
INSERT INTO `product_variants` VALUES (172, 85, 2, 1, 100, 350000.00, 299000.00);
INSERT INTO `product_variants` VALUES (173, 85, 3, 1, 100, 350000.00, 299000.00);
INSERT INTO `product_variants` VALUES (174, 85, 4, 1, 100, 350000.00, 299000.00);
INSERT INTO `product_variants` VALUES (175, 86, 1, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (176, 86, 2, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (177, 86, 3, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (178, 86, 4, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (179, 87, 1, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (180, 87, 2, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (181, 87, 3, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (182, 87, 4, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (183, 88, 1, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (184, 88, 2, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (185, 88, 3, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (186, 88, 4, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (187, 89, 1, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (188, 89, 2, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (189, 89, 3, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (190, 89, 4, 1, 100, 390000.00, 339000.00);
INSERT INTO `product_variants` VALUES (191, 90, 1, 1, 100, 350000.00, 299000.00);
INSERT INTO `product_variants` VALUES (192, 90, 2, 1, 100, 350000.00, 299000.00);
INSERT INTO `product_variants` VALUES (193, 90, 3, 1, 100, 350000.00, 299000.00);
INSERT INTO `product_variants` VALUES (194, 90, 4, 1, 100, 350000.00, 299000.00);
INSERT INTO `product_variants` VALUES (195, 91, 1, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (196, 91, 2, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (197, 91, 3, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (198, 91, 4, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (199, 92, 1, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (200, 92, 2, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (201, 92, 3, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (202, 92, 4, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (203, 93, 1, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (204, 93, 2, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (205, 93, 3, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (206, 93, 4, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (207, 94, 1, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (208, 94, 2, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (209, 94, 3, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (210, 94, 4, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (211, 95, 1, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (212, 95, 2, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (213, 95, 3, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (214, 95, 4, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (215, 96, 1, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (216, 96, 2, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (217, 96, 3, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (218, 96, 4, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (219, 97, 1, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (220, 97, 2, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (221, 97, 3, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (222, 97, 4, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (223, 98, 1, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (224, 98, 2, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (225, 98, 3, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (226, 98, 4, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (227, 99, 1, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (228, 99, 2, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (229, 99, 3, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (230, 99, 4, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (231, 100, 9, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (232, 100, 10, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (233, 100, 11, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (234, 100, 12, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (235, 100, 14, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (236, 101, 9, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (237, 101, 10, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (238, 101, 11, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (239, 101, 12, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (240, 101, 14, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (241, 102, 9, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (242, 102, 10, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (243, 102, 11, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (244, 102, 12, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (245, 102, 14, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (246, 103, 9, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (247, 103, 10, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (248, 103, 11, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (249, 103, 12, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (250, 103, 14, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (251, 104, 9, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (252, 104, 10, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (253, 104, 11, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (254, 104, 12, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (255, 104, 14, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (256, 105, 9, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (257, 105, 10, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (258, 105, 11, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (259, 105, 12, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (260, 105, 14, 7, 100, 690000.00, 619000.00);
INSERT INTO `product_variants` VALUES (261, 106, 9, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (262, 106, 10, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (263, 106, 11, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (264, 106, 12, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (265, 106, 14, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (266, 107, 9, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (267, 107, 10, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (268, 107, 11, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (269, 107, 12, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (270, 107, 14, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (271, 108, 9, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (272, 108, 10, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (273, 108, 11, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (274, 108, 12, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (275, 108, 14, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (276, 109, 9, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (277, 109, 10, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (278, 109, 11, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (279, 109, 12, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (280, 109, 14, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (281, 110, 9, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (282, 110, 10, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (283, 110, 11, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (284, 110, 12, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (285, 110, 14, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (286, 111, 9, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (287, 111, 10, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (288, 111, 11, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (289, 111, 12, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (290, 111, 14, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (291, 112, 9, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (292, 112, 10, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (293, 112, 11, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (294, 112, 12, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (295, 112, 14, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (296, 113, 9, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (297, 113, 10, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (298, 113, 11, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (299, 113, 12, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (300, 113, 14, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (301, 114, 9, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (302, 114, 10, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (303, 114, 11, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (304, 114, 12, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (305, 114, 14, 7, 100, 520000.00, 459000.00);
INSERT INTO `product_variants` VALUES (306, 115, 9, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (307, 115, 10, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (308, 115, 11, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (309, 115, 12, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (310, 115, 14, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (311, 116, 9, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (312, 116, 10, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (313, 116, 11, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (314, 116, 12, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (315, 116, 14, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (316, 117, 9, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (317, 117, 10, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (318, 117, 11, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (319, 117, 12, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (320, 117, 14, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (321, 118, 9, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (322, 118, 10, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (323, 118, 11, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (324, 118, 12, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (325, 118, 14, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (326, 119, 9, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (327, 119, 10, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (328, 119, 11, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (329, 119, 12, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (330, 119, 14, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (331, 120, 9, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (332, 120, 10, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (333, 120, 11, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (334, 120, 12, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (335, 120, 14, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (336, 121, 9, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (337, 121, 10, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (338, 121, 11, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (339, 121, 12, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (340, 121, 14, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (341, 122, 9, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (342, 122, 10, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (343, 122, 11, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (344, 122, 12, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (345, 122, 14, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (346, 123, 9, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (347, 123, 10, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (348, 123, 11, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (349, 123, 12, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (350, 123, 14, 1, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (351, 124, 9, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (352, 124, 10, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (353, 124, 11, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (354, 124, 12, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (355, 124, 14, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (356, 125, 9, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (357, 125, 10, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (358, 125, 11, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (359, 125, 12, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (360, 125, 14, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (361, 126, 9, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (362, 126, 10, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (363, 126, 11, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (364, 126, 12, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (365, 126, 14, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (366, 127, 9, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (367, 127, 10, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (368, 127, 11, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (369, 127, 12, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (370, 127, 14, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (371, 128, 9, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (372, 128, 10, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (373, 128, 11, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (374, 128, 12, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (375, 128, 14, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (376, 129, 9, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (377, 129, 10, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (378, 129, 11, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (379, 129, 12, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (380, 129, 14, 1, 100, 430000.00, 369000.00);
INSERT INTO `product_variants` VALUES (381, 130, 5, 1, 100, 790000.00, 699000.00);
INSERT INTO `product_variants` VALUES (382, 131, 5, 1, 100, 790000.00, 699000.00);
INSERT INTO `product_variants` VALUES (383, 132, 5, 1, 100, 790000.00, 699000.00);
INSERT INTO `product_variants` VALUES (384, 133, 5, 1, 100, 790000.00, 699000.00);
INSERT INTO `product_variants` VALUES (385, 134, 5, 1, 100, 790000.00, 699000.00);
INSERT INTO `product_variants` VALUES (386, 135, 5, 4, 100, 290000.00, 239000.00);
INSERT INTO `product_variants` VALUES (387, 136, 5, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (388, 137, 5, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (389, 138, 5, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (390, 139, 5, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (391, 140, 5, 1, 100, 250000.00, 199000.00);
INSERT INTO `product_variants` VALUES (392, 141, 5, 1, 100, 250000.00, 199000.00);

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
) ENGINE = InnoDB AUTO_INCREMENT = 142 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of products
-- ----------------------------
INSERT INTO `products` VALUES (38, 7, 'Ao Khoac Nu That Belt Form Straight', 'Sản phẩm Ao Khoac Nu That Belt Form Straight được thêm từ file zip ảnh.', 550000.00, 499000.00, 'img/products/NU/AOKHOAC/ao-khoac-nu-that-belt-form-straight/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (39, 4, 'SWE EAZY OFF-SHOULDER CROP', 'Sản phẩm SWE EAZY OFF-SHOULDER CROP được thêm từ file zip ảnh.', 320000.00, 269000.00, 'img/products/NU/AOKIEUNU/SWE EAZY OFF-SHOULDER CROP/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (40, 4, 'SWE FLOW TUBE TOP', 'Sản phẩm SWE FLOW TUBE TOP được thêm từ file zip ảnh.', 290000.00, 249000.00, 'img/products/NU/AOKIEUNU/SWE FLOW TUBE TOP/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (41, 4, 'SWE HONEY EDGE BRA', 'Sản phẩm SWE HONEY EDGE BRA được thêm từ file zip ảnh.', 290000.00, 249000.00, 'img/products/NU/AOKIEUNU/SWE HONEY EDGE BRA/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (42, 4, 'SWE OG BAND SPORT BRA', 'Sản phẩm SWE OG BAND SPORT BRA được thêm từ file zip ảnh.', 290000.00, 249000.00, 'img/products/NU/AOKIEUNU/SWE OG BAND SPORT BRA/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (43, 4, 'Ao Hai Day Denim Nu Cot No Form Regular', 'Sản phẩm Ao Hai Day Denim Nu Cot No Form Regular được thêm từ file zip ảnh.', 320000.00, 269000.00, 'img/products/NU/AOKIEUNU/ao-hai-day-denim-nu-cot-no-form-regular/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (44, 4, 'HADES INVERTED TEE', 'Sản phẩm HADES INVERTED TEE được thêm từ file zip ảnh.', 350000.00, 299000.00, 'img/products/NU/AOTHUN/HADES INVERTED TEE/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (45, 4, 'HADES NO ENTRY TEE', 'Sản phẩm HADES NO ENTRY TEE được thêm từ file zip ảnh.', 350000.00, 299000.00, 'img/products/NU/AOTHUN/HADES NO ENTRY TEE/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (46, 4, 'HADES WHISPER RACERBACK', 'Sản phẩm HADES WHISPER RACERBACK được thêm từ file zip ảnh.', 350000.00, 299000.00, 'img/products/NU/AOTHUN/HADES WHISPER RACERBACK/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (47, 4, 'Ao Thun Nu Crop Tay Ngan Co Nhan Metal Form Fitted', 'Sản phẩm Ao Thun Nu Crop Tay Ngan Co Nhan Metal Form Fitted được thêm từ file zip ảnh.', 240000.00, 199000.00, 'img/products/NU/AOTHUN/ao-thun-nu-crop-tay-ngan-co-nhan-metal-form-fitted/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (48, 4, 'Ao Thun Nu Crop Tay Ngan Cotton Theu Chu Regular', 'Sản phẩm Ao Thun Nu Crop Tay Ngan Cotton Theu Chu Regular được thêm từ file zip ảnh.', 240000.00, 199000.00, 'img/products/NU/AOTHUN/ao-thun-nu-crop-tay-ngan-cotton-theu-chu-regular/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (49, 4, 'Ao Thun Nu Tay Ngan 100 Cotton Phoi Vien Tay Co', 'Sản phẩm Ao Thun Nu Tay Ngan 100 Cotton Phoi Vien Tay Co được thêm từ file zip ảnh.', 240000.00, 199000.00, 'img/products/NU/AOTHUN/ao-thun-nu-tay-ngan-100-cotton-phoi-vien-tay-co/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (50, 4, 'Ao Thun Nu Tay Ngan Cotton Ke Soc Ngang Regular', 'Sản phẩm Ao Thun Nu Tay Ngan Cotton Ke Soc Ngang Regular được thêm từ file zip ảnh.', 240000.00, 199000.00, 'img/products/NU/AOTHUN/ao-thun-nu-tay-ngan-cotton-ke-soc-ngang-regular/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (51, 4, 'Ao Thun Nu Vai Texture Fitted', 'Sản phẩm Ao Thun Nu Vai Texture Fitted được thêm từ file zip ảnh.', 240000.00, 199000.00, 'img/products/NU/AOTHUN/ao-thun-nu-vai-texture-fitted/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (52, 4, 'Ao Thun Tam Nu Cuon Beo Tay Dai Form Fitted', 'Sản phẩm Ao Thun Tam Nu Cuon Beo Tay Dai Form Fitted được thêm từ file zip ảnh.', 240000.00, 199000.00, 'img/products/NU/AOTHUN/ao-thun-tam-nu-cuon-beo-tay-dai-form-fitted/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (53, 4, 'Ao Thun Tay Ngan Nu Hinh In Fitted', 'Sản phẩm Ao Thun Tay Ngan Nu Hinh In Fitted được thêm từ file zip ảnh.', 240000.00, 199000.00, 'img/products/NU/AOTHUN/ao-thun-tay-ngan-nu-hinh-in-fitted/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (54, 4, 'Ao Thun Tay Ngan Nu Soc Co Tron Slim', 'Sản phẩm Ao Thun Tay Ngan Nu Soc Co Tron Slim được thêm từ file zip ảnh.', 240000.00, 199000.00, 'img/products/NU/AOTHUN/ao-thun-tay-ngan-nu-soc-co-tron-slim/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (55, 6, 'Chan Vay Nu Ban Lung To A Line', 'Sản phẩm Chan Vay Nu Ban Lung To A Line được thêm từ file zip ảnh.', 340000.00, 289000.00, 'img/products/NU/CHANVAY/chan-vay-nu-ban-lung-to-a-line/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (56, 3, 'HADES ASTRAL DENIM JACKET', 'Sản phẩm HADES ASTRAL DENIM JACKET được thêm từ file zip ảnh.', 890000.00, 799000.00, 'img/products/Nam/AOKHOAC/HADES ASTRAL DENIM JACKET/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (57, 3, 'HADES ENLISTED ZIP HOODIE', 'Sản phẩm HADES ENLISTED ZIP HOODIE được thêm từ file zip ảnh.', 890000.00, 799000.00, 'img/products/Nam/AOKHOAC/HADES ENLISTED ZIP HOODIE/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (58, 3, 'HADES INDUSRTRIAL EDGE HOODIE', 'Sản phẩm HADES INDUSRTRIAL EDGE HOODIE được thêm từ file zip ảnh.', 890000.00, 799000.00, 'img/products/Nam/AOKHOAC/HADES INDUSRTRIAL EDGE HOODIE/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (59, 3, 'HADES OBSTREPEROUS VARSITY JACKET', 'Sản phẩm HADES OBSTREPEROUS VARSITY JACKET được thêm từ file zip ảnh.', 890000.00, 799000.00, 'img/products/Nam/AOKHOAC/HADES OBSTREPEROUS VARSITY JACKET/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (60, 3, 'HADES REIGN VELVET JACKET', 'Sản phẩm HADES REIGN VELVET JACKET được thêm từ file zip ảnh.', 890000.00, 799000.00, 'img/products/Nam/AOKHOAC/HADES REIGN VELVET JACKET/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (61, 3, 'HADES TACTICAL CAMO JACKET', 'Sản phẩm HADES TACTICAL CAMO JACKET được thêm từ file zip ảnh.', 890000.00, 799000.00, 'img/products/Nam/AOKHOAC/HADES TACTICAL CAMO JACKET/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (62, 3, 'HADES TRANZIT TRACK JACKET', 'Sản phẩm HADES TRANZIT TRACK JACKET được thêm từ file zip ảnh.', 890000.00, 799000.00, 'img/products/Nam/AOKHOAC/HADES TRANZIT TRACK JACKET/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (63, 3, 'HADES VOID DRIFTER ZIP HOODIE', 'Sản phẩm HADES VOID DRIFTER ZIP HOODIE được thêm từ file zip ảnh.', 890000.00, 799000.00, 'img/products/Nam/AOKHOAC/HADES VOID DRIFTER ZIP HOODIE/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (64, 3, 'HADES WASHED MATRIX JACKET', 'Sản phẩm HADES WASHED MATRIX JACKET được thêm từ file zip ảnh.', 890000.00, 799000.00, 'img/products/Nam/AOKHOAC/HADES WASHED MATRIX JACKET/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (65, 3, 'Ao Khoac Aston', 'Sản phẩm Ao Khoac Aston được thêm từ file zip ảnh.', 550000.00, 499000.00, 'img/products/Nam/AOKHOAC/ao-khoac-aston/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (66, 3, 'Ao Khoac Nam Jacky', 'Sản phẩm Ao Khoac Nam Jacky được thêm từ file zip ảnh.', 550000.00, 499000.00, 'img/products/Nam/AOKHOAC/ao-khoac-nam-jacky/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (67, 3, 'Ao Khoac Orin', 'Sản phẩm Ao Khoac Orin được thêm từ file zip ảnh.', 550000.00, 499000.00, 'img/products/Nam/AOKHOAC/ao-khoac-orin/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (68, 1, 'HADES DEAR SHIRT', 'Sản phẩm HADES DEAR SHIRT được thêm từ file zip ảnh.', 520000.00, 459000.00, 'img/products/Nam/AOSOMI/HADES DEAR SHIRT/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (69, 1, 'HADES FADE OUT WOVEN SHIRT', 'Sản phẩm HADES FADE OUT WOVEN SHIRT được thêm từ file zip ảnh.', 520000.00, 459000.00, 'img/products/Nam/AOSOMI/HADES FADE OUT WOVEN SHIRT/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (70, 1, 'HADES SILENT GAZE SHIRT', 'Sản phẩm HADES SILENT GAZE SHIRT được thêm từ file zip ảnh.', 520000.00, 459000.00, 'img/products/Nam/AOSOMI/HADES SILENT GAZE SHIRT/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (71, 1, 'HADES THREADLINE SHIRT', 'Sản phẩm HADES THREADLINE SHIRT được thêm từ file zip ảnh.', 520000.00, 459000.00, 'img/products/Nam/AOSOMI/HADES THREADLINE SHIRT/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (72, 1, 'HADES URBAN LINES SHIRT', 'Sản phẩm HADES URBAN LINES SHIRT được thêm từ file zip ảnh.', 520000.00, 459000.00, 'img/products/Nam/AOSOMI/HADES URBAN LINES SHIRT/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (73, 1, 'Ao So Mi Justin', 'Sản phẩm Ao So Mi Justin được thêm từ file zip ảnh.', 390000.00, 329000.00, 'img/products/Nam/AOSOMI/ao-so-mi-justin/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (74, 1, 'Ao So Mi Nam Extra Cotton', 'Sản phẩm Ao So Mi Nam Extra Cotton được thêm từ file zip ảnh.', 390000.00, 329000.00, 'img/products/Nam/AOSOMI/ao-so-mi-nam-extra-cotton/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (75, 1, 'Ao So Mi Nam Linen', 'Sản phẩm Ao So Mi Nam Linen được thêm từ file zip ảnh.', 390000.00, 329000.00, 'img/products/Nam/AOSOMI/ao-so-mi-nam-linen/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (76, 1, 'Ao So Mi Nam Oxford', 'Sản phẩm Ao So Mi Nam Oxford được thêm từ file zip ảnh.', 390000.00, 329000.00, 'img/products/Nam/AOSOMI/ao-so-mi-nam-oxford/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (77, 1, 'Ao So Mi Nam Ribbed', 'Sản phẩm Ao So Mi Nam Ribbed được thêm từ file zip ảnh.', 390000.00, 329000.00, 'img/products/Nam/AOSOMI/ao-so-mi-nam-ribbed/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (78, 1, 'Ao So Mi Nam Tay Ngan Haller', 'Sản phẩm Ao So Mi Nam Tay Ngan Haller được thêm từ file zip ảnh.', 390000.00, 329000.00, 'img/products/Nam/AOSOMI/ao-so-mi-nam-tay-ngan-haller/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (79, 1, 'Ao So Mi Oxford Premium', 'Sản phẩm Ao So Mi Oxford Premium được thêm từ file zip ảnh.', 390000.00, 329000.00, 'img/products/Nam/AOSOMI/ao-so-mi-oxford-premium/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (80, 1, 'Ao So Mi Poplin', 'Sản phẩm Ao So Mi Poplin được thêm từ file zip ảnh.', 390000.00, 329000.00, 'img/products/Nam/AOSOMI/ao-so-mi-poplin/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (81, 1, 'Ao So Mi Santo', 'Sản phẩm Ao So Mi Santo được thêm từ file zip ảnh.', 390000.00, 329000.00, 'img/products/Nam/AOSOMI/ao-so-mi-santo/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (82, 1, 'HADES 777 JERSEY MESH', 'Sản phẩm HADES 777 JERSEY MESH được thêm từ file zip ảnh.', 390000.00, 339000.00, 'img/products/Nam/AOTHUN/HADES 777 JERSEY MESH/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (83, 1, 'HADES ATHLETE IGNITE JERSEY', 'Sản phẩm HADES ATHLETE IGNITE JERSEY được thêm từ file zip ảnh.', 390000.00, 339000.00, 'img/products/Nam/AOTHUN/HADES ATHLETE IGNITE JERSEY/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (84, 1, 'HADES FLUFFY GRILL TEE', 'Sản phẩm HADES FLUFFY GRILL TEE được thêm từ file zip ảnh.', 350000.00, 299000.00, 'img/products/Nam/AOTHUN/HADES FLUFFY GRILL TEE/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (85, 1, 'HADES GLORY WASH TEE', 'Sản phẩm HADES GLORY WASH TEE được thêm từ file zip ảnh.', 350000.00, 299000.00, 'img/products/Nam/AOTHUN/HADES GLORY WASH TEE/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (86, 1, 'HADES LAST KISS LONGSLEEVE', 'Sản phẩm HADES LAST KISS LONGSLEEVE được thêm từ file zip ảnh.', 390000.00, 339000.00, 'img/products/Nam/AOTHUN/HADES LAST KISS LONGSLEEVE/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (87, 1, 'HADES LUMINOUS 2K MESH JERSEY', 'Sản phẩm HADES LUMINOUS 2K MESH JERSEY được thêm từ file zip ảnh.', 390000.00, 339000.00, 'img/products/Nam/AOTHUN/HADES LUMINOUS 2K MESH JERSEY/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (88, 1, 'HADES STAMPED KNITTED TEE', 'Sản phẩm HADES STAMPED KNITTED TEE được thêm từ file zip ảnh.', 390000.00, 339000.00, 'img/products/Nam/AOTHUN/HADES STAMPED KNITTED TEE/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (89, 1, 'HADES TROOPER CAMO LONGSLEEVE TEE', 'Sản phẩm HADES TROOPER CAMO LONGSLEEVE TEE được thêm từ file zip ảnh.', 390000.00, 339000.00, 'img/products/Nam/AOTHUN/HADES TROOPER CAMO LONGSLEEVE TEE/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (90, 1, 'HADES VALOR GRIP TEE', 'Sản phẩm HADES VALOR GRIP TEE được thêm từ file zip ảnh.', 350000.00, 299000.00, 'img/products/Nam/AOTHUN/HADES VALOR GRIP TEE/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (91, 1, 'Ao Thun Basic Usa', 'Sản phẩm Ao Thun Basic Usa được thêm từ file zip ảnh.', 250000.00, 199000.00, 'img/products/Nam/AOTHUN/ao-thun-basic-usa/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (92, 1, 'Ao Thun Dai Tay Jackson', 'Sản phẩm Ao Thun Dai Tay Jackson được thêm từ file zip ảnh.', 250000.00, 199000.00, 'img/products/Nam/AOTHUN/ao-thun-dai-tay-jackson/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (93, 1, 'Ao Thun Galor', 'Sản phẩm Ao Thun Galor được thêm từ file zip ảnh.', 250000.00, 199000.00, 'img/products/Nam/AOTHUN/ao-thun-galor/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (94, 1, 'Ao Thun Lio', 'Sản phẩm Ao Thun Lio được thêm từ file zip ảnh.', 250000.00, 199000.00, 'img/products/Nam/AOTHUN/ao-thun-lio/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (95, 1, 'Ao Thun Mike', 'Sản phẩm Ao Thun Mike được thêm từ file zip ảnh.', 250000.00, 199000.00, 'img/products/Nam/AOTHUN/ao-thun-mike/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (96, 1, 'Ao Thun Nam Horiz Shirt', 'Sản phẩm Ao Thun Nam Horiz Shirt được thêm từ file zip ảnh.', 250000.00, 199000.00, 'img/products/Nam/AOTHUN/ao-thun-nam-horiz-shirt/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (97, 1, 'Ao Thun Nam Vai Knit Jersey', 'Sản phẩm Ao Thun Nam Vai Knit Jersey được thêm từ file zip ảnh.', 250000.00, 199000.00, 'img/products/Nam/AOTHUN/ao-thun-nam-vai-knit-jersey/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (98, 1, 'Ao Thun Tank Top', 'Sản phẩm Ao Thun Tank Top được thêm từ file zip ảnh.', 250000.00, 199000.00, 'img/products/Nam/AOTHUN/ao-thun-tank-top/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (99, 1, 'Ao Thun Toby', 'Sản phẩm Ao Thun Toby được thêm từ file zip ảnh.', 250000.00, 199000.00, 'img/products/Nam/AOTHUN/ao-thun-toby/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (100, 2, 'HADES DISSENT TROUSERS PANTS', 'Sản phẩm HADES DISSENT TROUSERS PANTS được thêm từ file zip ảnh.', 690000.00, 619000.00, 'img/products/Nam/QUANJEAN/HADES DISSENT TROUSERS PANTS/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (101, 2, 'HADES DUNE RUPTUNE WASH JEANS', 'Sản phẩm HADES DUNE RUPTUNE WASH JEANS được thêm từ file zip ảnh.', 690000.00, 619000.00, 'img/products/Nam/QUANJEAN/HADES DUNE RUPTUNE WASH JEANS/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (102, 2, 'HADES PINK STARDUST PANTS', 'Sản phẩm HADES PINK STARDUST PANTS được thêm từ file zip ảnh.', 690000.00, 619000.00, 'img/products/Nam/QUANJEAN/HADES PINK STARDUST PANTS/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (103, 2, 'HADES REPEAT SCRIPT LOOSEFIT JEANS', 'Sản phẩm HADES REPEAT SCRIPT LOOSEFIT JEANS được thêm từ file zip ảnh.', 690000.00, 619000.00, 'img/products/Nam/QUANJEAN/HADES REPEAT SCRIPT LOOSEFIT JEANS/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (104, 2, 'HADES WASH BAGGY DENIM TROUSERS', 'Sản phẩm HADES WASH BAGGY DENIM TROUSERS được thêm từ file zip ảnh.', 690000.00, 619000.00, 'img/products/Nam/QUANJEAN/HADES WASH BAGGY DENIM TROUSERS/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (105, 2, 'HADES WRECKAGE JEANS', 'Sản phẩm HADES WRECKAGE JEANS được thêm từ file zip ảnh.', 690000.00, 619000.00, 'img/products/Nam/QUANJEAN/HADES WRECKAGE JEANS/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (106, 2, 'Quan Denim Nam Balloon', 'Sản phẩm Quan Denim Nam Balloon được thêm từ file zip ảnh.', 520000.00, 459000.00, 'img/products/Nam/QUANJEAN/quan-denim-nam-balloon/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (107, 2, 'Quan Denim Nam Cocoon', 'Sản phẩm Quan Denim Nam Cocoon được thêm từ file zip ảnh.', 520000.00, 459000.00, 'img/products/Nam/QUANJEAN/quan-denim-nam-cocoon/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (108, 2, 'Quan Denim Nam Gap Ong Form Straight Crop', 'Sản phẩm Quan Denim Nam Gap Ong Form Straight Crop được thêm từ file zip ảnh.', 520000.00, 459000.00, 'img/products/Nam/QUANJEAN/quan-denim-nam-gap-ong-form-straight-crop/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (109, 2, 'Quan Denim Nam Ong Rong Rui Suon Form Loose', 'Sản phẩm Quan Denim Nam Ong Rong Rui Suon Form Loose được thêm từ file zip ảnh.', 520000.00, 459000.00, 'img/products/Nam/QUANJEAN/quan-denim-nam-ong-rong-rui-suon-form-loose/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (110, 2, 'Quan Denim Nam Tapered', 'Sản phẩm Quan Denim Nam Tapered được thêm từ file zip ảnh.', 520000.00, 459000.00, 'img/products/Nam/QUANJEAN/quan-denim-nam-tapered/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (111, 2, 'Quan Denim Nam Wide Leg', 'Sản phẩm Quan Denim Nam Wide Leg được thêm từ file zip ảnh.', 520000.00, 459000.00, 'img/products/Nam/QUANJEAN/quan-denim-nam-wide-leg/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (112, 2, 'Quan Denim Nam Xep Li Barrel', 'Sản phẩm Quan Denim Nam Xep Li Barrel được thêm từ file zip ảnh.', 520000.00, 459000.00, 'img/products/Nam/QUANJEAN/quan-denim-nam-xep-li-barrel/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (113, 2, 'Quan Jeans Nam Den Basic Musthave Slim Cropped', 'Sản phẩm Quan Jeans Nam Den Basic Musthave Slim Cropped được thêm từ file zip ảnh.', 520000.00, 459000.00, 'img/products/Nam/QUANJEAN/quan-jeans-nam-den-basic-musthave-slim-cropped/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (114, 2, 'Quan Jeans Nam Navy Tron Dang Om Slim', 'Sản phẩm Quan Jeans Nam Navy Tron Dang Om Slim được thêm từ file zip ảnh.', 520000.00, 459000.00, 'img/products/Nam/QUANJEAN/quan-jeans-nam-navy-tron-dang-om-slim/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (115, 2, 'HADES CAMO MESH SHORT - WHITE', 'Sản phẩm HADES CAMO MESH SHORT - WHITE được thêm từ file zip ảnh.', 290000.00, 239000.00, 'img/products/Nam/QUANSHORT/HADES CAMO MESH SHORT - WHITE/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (116, 2, 'Quan Short Denim Nam Form Straight', 'Sản phẩm Quan Short Denim Nam Form Straight được thêm từ file zip ảnh.', 290000.00, 239000.00, 'img/products/Nam/QUANSHORT/quan-short-denim-nam-form-straight/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (117, 2, 'Quan Short Nam Cotton Spandex Dieu Gan Form Loose', 'Sản phẩm Quan Short Nam Cotton Spandex Dieu Gan Form Loose được thêm từ file zip ảnh.', 290000.00, 239000.00, 'img/products/Nam/QUANSHORT/quan-short-nam-cotton-spandex-dieu-gan-form-loose/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (118, 2, 'Quan Short Nam Double Face Form Relax', 'Sản phẩm Quan Short Nam Double Face Form Relax được thêm từ file zip ảnh.', 290000.00, 239000.00, 'img/products/Nam/QUANSHORT/quan-short-nam-double-face-form-relax/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (119, 2, 'Quan Short Nam Hoa Tiet Cotton Lung Thun', 'Sản phẩm Quan Short Nam Hoa Tiet Cotton Lung Thun được thêm từ file zip ảnh.', 290000.00, 239000.00, 'img/products/Nam/QUANSHORT/quan-short-nam-hoa-tiet-cotton-lung-thun/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (120, 2, 'Quan Short Nam Kieu Tron Form Straight', 'Sản phẩm Quan Short Nam Kieu Tron Form Straight được thêm từ file zip ảnh.', 290000.00, 239000.00, 'img/products/Nam/QUANSHORT/quan-short-nam-kieu-tron-form-straight/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (121, 2, 'Quan Short Nam Nylon Vai Du Tui Dap Relax', 'Sản phẩm Quan Short Nam Nylon Vai Du Tui Dap Relax được thêm từ file zip ảnh.', 290000.00, 239000.00, 'img/products/Nam/QUANSHORT/quan-short-nam-nylon-vai-du-tui-dap-relax/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (122, 2, 'Quan Short Nam Premium Straight', 'Sản phẩm Quan Short Nam Premium Straight được thêm từ file zip ảnh.', 290000.00, 239000.00, 'img/products/Nam/QUANSHORT/quan-short-nam-premium-straight/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (123, 2, 'Quan Short Nam Vai Du Tui Dap Form Relax', 'Sản phẩm Quan Short Nam Vai Du Tui Dap Form Relax được thêm từ file zip ảnh.', 290000.00, 239000.00, 'img/products/Nam/QUANSHORT/quan-short-nam-vai-du-tui-dap-form-relax/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (124, 2, 'Quan Tay Dai Nam Slim', 'Sản phẩm Quan Tay Dai Nam Slim được thêm từ file zip ảnh.', 430000.00, 369000.00, 'img/products/Nam/QUANTAY/quan-tay-dai-nam-slim/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (125, 2, 'Quan Tay Dai Nam Slim Cropped', 'Sản phẩm Quan Tay Dai Nam Slim Cropped được thêm từ file zip ảnh.', 430000.00, 369000.00, 'img/products/Nam/QUANTAY/quan-tay-dai-nam-slim-cropped/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (126, 2, 'Quan Tay Nam Dai Chat Lieu Kaki Form Slim', 'Sản phẩm Quan Tay Nam Dai Chat Lieu Kaki Form Slim được thêm từ file zip ảnh.', 430000.00, 369000.00, 'img/products/Nam/QUANTAY/quan-tay-nam-dai-chat-lieu-kaki-form-slim/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (127, 2, 'Quan Tay Nam Dai Lung Chun Dieu Chinh Form Slim', 'Sản phẩm Quan Tay Nam Dai Lung Chun Dieu Chinh Form Slim được thêm từ file zip ảnh.', 430000.00, 369000.00, 'img/products/Nam/QUANTAY/quan-tay-nam-dai-lung-chun-dieu-chinh-form-slim/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (128, 2, 'Quan Tay Nam Dai Ui Ly Truoc Form Slim', 'Sản phẩm Quan Tay Nam Dai Ui Ly Truoc Form Slim được thêm từ file zip ảnh.', 430000.00, 369000.00, 'img/products/Nam/QUANTAY/quan-tay-nam-dai-ui-ly-truoc-form-slim/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (129, 2, 'Quan Vai Nam Dai Ong Om Form Slim', 'Sản phẩm Quan Vai Nam Dai Ong Om Form Slim được thêm từ file zip ảnh.', 430000.00, 369000.00, 'img/products/Nam/QUANTAY/quan-vai-nam-dai-ong-om-form-slim/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (130, 10, 'HADES BACKPACK LEATHER 24', 'Sản phẩm HADES BACKPACK LEATHER 24 ', 790000.00, 699000.00, 'img/products/PHUKIEN/BAG/HADES BACKPACK LEATHER 24/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (131, 10, 'HADES NOMAD BACKPACK', 'Sản phẩm HADES NOMAD BACKPACK ', 790000.00, 699000.00, 'img/products/PHUKIEN/BAG/HADES NOMAD BACKPACK/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (132, 10, 'HADES OBSIDIAN LEATHER BAG', 'Sản phẩm HADES OBSIDIAN LEATHER BAG ', 790000.00, 699000.00, 'img/products/PHUKIEN/BAG/HADES OBSIDIAN LEATHER BAG/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (133, 10, 'HADES QUILTED ARMOR BACKPACK', 'Sản phẩm HADES QUILTED ARMOR BACKPACK ', 790000.00, 699000.00, 'img/products/PHUKIEN/BAG/HADES QUILTED ARMOR BACKPACK/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (134, 10, 'HADES VOYAGER BACKPACK', 'Sản phẩm HADES VOYAGER BACKPACK ', 790000.00, 699000.00, 'img/products/PHUKIEN/BAG/HADES VOYAGER BACKPACK/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (135, 10, 'HADES CLOUD NINE SCARF', 'Sản phẩm HADES CLOUD NINE SCARF ', 290000.00, 239000.00, 'img/products/PHUKIEN/KHAN/HADES CLOUD NINE SCARF/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (136, 10, 'HADES CREST DAD CAP', 'Sản phẩm HADES CREST DAD CAP ', 250000.00, 199000.00, 'img/products/PHUKIEN/NON/HADES CREST DAD CAP/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (137, 10, 'HADES DENIM CAMP CAP', 'Sản phẩm HADES DENIM CAMP CAP được thêm từ file zip ảnh.', 250000.00, 199000.00, 'img/products/PHUKIEN/NON/HADES DENIM CAMP CAP/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (138, 10, 'HADES DISTRESSED DENIM CAP', 'Sản phẩm HADES DISTRESSED DENIM CAP', 250000.00, 199000.00, 'img/products/PHUKIEN/NON/HADES DISTRESSED DENIM CAP/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (139, 10, 'HADES DISTRICT 1 CAP', 'Sản phẩm HADES DISTRICT 1 CAP ', 250000.00, 199000.00, 'img/products/PHUKIEN/NON/HADES DISTRICT 1 CAP/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (140, 10, 'HADES ICONIC STAR SNAPBACK', 'Sản phẩm HADES ICONIC STAR SNAPBACK', 250000.00, 199000.00, 'img/products/PHUKIEN/NON/HADES ICONIC STAR SNAPBACK/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');
INSERT INTO `products` VALUES (141, 10, 'Non Luoi Trai Soi Chuoi Freesize', 'Sản phẩm Non Luoi Trai Soi Chuoi Freesize ', 250000.00, 199000.00, 'img/products/PHUKIEN/NON/non-luoi-trai-soi-chuoi-freesize/main.jpg', 0, 'Đang bán', '2026-03-30 13:26:20');

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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of reviews
-- ----------------------------
INSERT INTO `reviews` VALUES (1, 1, 1, 5, 'Chất vải sờ siêu thích, đóng gói cực kì cẩn thận. Lần sau mình sẽ ủng hộ shop tiếp. Rất hài lòng !!', '2023-11-20 10:20:00');
INSERT INTO `reviews` VALUES (2, 1, 1, 4, 'Áo đẹp, form dáng ok nhưng giao hàng hơi chậm chút do qua lễ.', '2023-11-25 14:15:00');
INSERT INTO `reviews` VALUES (3, 2, 1, 5, 'Váy y chang hình shop đăng, mặc tôn dáng lắm. Giá này mua quá hời lun!', '2023-11-26 09:30:00');
INSERT INTO `reviews` VALUES (4, 1, 3, 3, 'sad', '2026-03-20 07:23:20');

-- ----------------------------
-- Table structure for sizes
-- ----------------------------
DROP TABLE IF EXISTS `sizes`;
CREATE TABLE `sizes`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_order` int NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sizes
-- ----------------------------
INSERT INTO `sizes` VALUES (1, 'S', 1);
INSERT INTO `sizes` VALUES (2, 'M', 2);
INSERT INTO `sizes` VALUES (3, 'L', 3);
INSERT INTO `sizes` VALUES (4, 'XL', 4);
INSERT INTO `sizes` VALUES (5, 'FREESIZE', 0);
INSERT INTO `sizes` VALUES (6, 'XS', 1);
INSERT INTO `sizes` VALUES (7, 'XXL', 6);
INSERT INTO `sizes` VALUES (8, '28', 10);
INSERT INTO `sizes` VALUES (9, '29', 11);
INSERT INTO `sizes` VALUES (10, '30', 12);
INSERT INTO `sizes` VALUES (11, '31', 13);
INSERT INTO `sizes` VALUES (12, '32', 14);
INSERT INTO `sizes` VALUES (13, '33', 15);
INSERT INTO `sizes` VALUES (14, '34', 16);
INSERT INTO `sizes` VALUES (15, '36', 17);
INSERT INTO `sizes` VALUES (16, '38', 18);
INSERT INTO `sizes` VALUES (17, '40', 19);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `google_sub` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `auth_provider` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'LOCAL',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'USER',
  `full_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `avatar_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
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
  UNIQUE INDEX `email`(`email` ASC) USING BTREE,
  UNIQUE INDEX `uq_users_google_sub`(`google_sub` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'khachhangtest', '123456', 'test@gmail.com', NULL, 'LOCAL', 'admin', 'Khách hàng Test', NULL, NULL, '', '', '', NULL, 1, 'ACTIVE', '2026-03-20 04:19:44', NULL);
INSERT INTO `users` VALUES (3, 'thutran2002', '$2a$12$CC3jSe2l0hdq9FnKu2KvhO66sfVvqRqPpO24CXIAgWP33pANVrPjq', '23130318@st.hcmuaf.edu.vn', NULL, 'LOCAL', 'admin', 'Huỳnh Khánh Toàn', NULL, '2026-03-10', 'male', '0921321323', '', NULL, 1, 'BLOCKED', '2026-03-19 20:31:38', NULL);
INSERT INTO `users` VALUES (4, 'thutran311', '$2a$12$bxmePCpNI78Bzxa0E9yoSe1.2PJ.e8.ETIy4ilE8NlKrz.gaHxaUC', 'toanhuynh@gmail.com', NULL, 'LOCAL', 'admin', 'Đàm Vĩnh Hưng', NULL, NULL, '', '0921321323', '', NULL, 1, 'ACTIVE', '2026-03-20 16:08:10', NULL);
INSERT INTO `users` VALUES (5, 'khanhtoan2102', '$2a$12$2W0JcQYwFBLbXYIHxqpQuOGLXN/AurkFXuMQgWvUW5hflz5Fyri5S', 'toanhuynh212@gmail.com', NULL, 'LOCAL', 'admin', 'Lê Đạt Web', NULL, NULL, '', '0123456789', '', NULL, 1, 'ACTIVE', '2026-03-21 02:26:10', NULL);
INSERT INTO `users` VALUES (6, 'Thune', '$2a$12$Lfo9zCzmDTd9sfrCM9UTEuO2vkahKF./AhqmlKHACzBZE2wOIStWK', '23130082@st.hcmuaf.edu.vn', NULL, 'LOCAL', 'USER', 'Trần Thị Minh Thư', NULL, '2026-03-04', 'female', NULL, NULL, NULL, 1, 'ACTIVE', '2026-03-21 02:41:10', NULL);
INSERT INTO `users` VALUES (7, 'WebToiChoi', '$2a$12$dqMoM5q9kvb8mcKwb/Jwu.1kAxvnm8jW/bto/UB4alcaNIC/QTjJW', 'webne26@gmail.com', NULL, 'LOCAL', 'USER', 'Nguyen Van A', NULL, '2026-03-10', 'male', NULL, NULL, NULL, 1, 'BLOCKED', '2026-03-21 02:56:10', NULL);
INSERT INTO `users` VALUES (8, 'handeptrai', '$2a$12$xRl.SFgyqGHMqoKtoVlJWuLFYgkMZ5ynqpoS0XrucMXdtD5L27Ema', '23130087@st.hcmuaf.edu.vn', NULL, 'LOCAL', 'admin', 'Nguyễn Văn Anh Hàn', 'media/avatar/avatar_user_8_1776255174549.png', '2005-05-05', 'male', 'ip17', 'Hồ Chí Minh', NULL, 1, 'ACTIVE', '2026-03-21 19:51:55', NULL);
INSERT INTO `users` VALUES (9, 'nguyenvananhhan555', '$2a$12$oae7Kk.SpsOjr5MGcTWRj.iSLhsAifJl4za0tTw/1DT3COaE.0P3i', 'nguyenvananhhan555@gmail.com', '110404817350622964648', 'GOOGLE', 'USER', 'Hàn Nguyễn Văn Anh', 'https://lh3.googleusercontent.com/a/ACg8ocJvoz9MGvwKsJSMquUHROpc7A5DEPpEHbGMiOLTcvoHKu8MRqU=s96-c', NULL, NULL, NULL, NULL, NULL, 1, 'ACTIVE', '2026-04-07 20:08:29', NULL);

SET FOREIGN_KEY_CHECKS = 1;
