-- Migration: Tạo bảng roles & role_permissions
-- Hệ thống phân quyền cho Admin

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `role_permissions`;
DROP TABLE IF EXISTS `roles`;

CREATE TABLE `roles` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
    `description` TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
    `is_system` TINYINT(1) DEFAULT 0 COMMENT '1 = role hệ thống (Admin), không được sửa/xoá',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_roles_name` (`name`)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

CREATE TABLE `role_permissions` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `role_id` INT NOT NULL,
    `module` VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
        COMMENT 'user, category, product, order, return, banner, blog, contact, warehouse, role',
    `action` VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
        COMMENT 'view_list, view_detail, add, edit, delete, lock',
    `allowed` TINYINT(1) DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_role_module_action` (`role_id`, `module`, `action`),
    CONSTRAINT `fk_rp_role` FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON DELETE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- Dữ liệu mặc định: Role Admin (toàn quyền)
INSERT INTO `roles` (`name`, `description`, `is_system`) VALUES
('Admin', 'Quản trị viên - Toàn quyền hệ thống', 1);

-- Chèn toàn bộ quyền cho Admin (role_id = 1)
INSERT INTO `role_permissions` (`role_id`, `module`, `action`, `allowed`) VALUES
-- Module: user
(1, 'user', 'view_list', 1),
(1, 'user', 'view_detail', 1),
(1, 'user', 'add', 1),
(1, 'user', 'edit', 1),
(1, 'user', 'lock', 1),
-- Module: category
(1, 'category', 'view_list', 1),
(1, 'category', 'view_detail', 1),
(1, 'category', 'add', 1),
(1, 'category', 'edit', 1),
(1, 'category', 'delete', 1),
(1, 'category', 'lock', 1),
-- Module: product
(1, 'product', 'view_list', 1),
(1, 'product', 'view_detail', 1),
(1, 'product', 'add', 1),
(1, 'product', 'edit', 1),
(1, 'product', 'delete', 1),
-- Module: order
(1, 'order', 'view_list', 1),
(1, 'order', 'view_detail', 1),
(1, 'order', 'edit', 1),
-- Module: return
(1, 'return', 'view_list', 1),
(1, 'return', 'view_detail', 1),
(1, 'return', 'edit', 1),
-- Module: banner
(1, 'banner', 'view_list', 1),
(1, 'banner', 'view_detail', 1),
(1, 'banner', 'add', 1),
(1, 'banner', 'edit', 1),
(1, 'banner', 'delete', 1),
(1, 'banner', 'lock', 1),
-- Module: blog
(1, 'blog', 'view_list', 1),
(1, 'blog', 'view_detail', 1),
(1, 'blog', 'add', 1),
(1, 'blog', 'edit', 1),
(1, 'blog', 'delete', 1),
-- Module: contact
(1, 'contact', 'view_list', 1),
(1, 'contact', 'view_detail', 1),
(1, 'contact', 'edit', 1),
-- Module: warehouse
(1, 'warehouse', 'view_list', 1),
(1, 'warehouse', 'view_detail', 1),
(1, 'warehouse', 'add', 1),
(1, 'warehouse', 'edit', 1),
-- Module: role
(1, 'role', 'view_list', 1),
(1, 'role', 'view_detail', 1),
(1, 'role', 'add', 1),
(1, 'role', 'edit', 1),
(1, 'role', 'delete', 1);

ALTER TABLE `users` ADD COLUMN `role_id` INT NULL;
ALTER TABLE `users` ADD CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON DELETE SET NULL;
