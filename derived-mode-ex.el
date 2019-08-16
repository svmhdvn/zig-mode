;;; derived-mode-ex.el --- example of a CC Mode derived mode for a new language

;; Author:     2002 Martin Stjernholm
;; Maintainer: Unmaintained
;; Created:    October 2002
;; Version:    See cc-mode.el
;; Keywords:   c languages oop

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;; 
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; This is a simple example of a separate mode derived from CC Mode
;; for a hypothetical language called C: (pronounced "big nose") that
;; is similar to Java.  It's provided as a guide to show how to use CC
;; Mode as the base in a clean way without depending on the internal
;; implementation details.
;;
;; Currently it only shows the bare basics in mode setup and how to
;; use the language constant system to change some of the keywords
;; that are recognized in various situations.

;; Note: The interface used in this file requires CC Mode 5.30 or
;; later.

;;; Code:

(require 'cc-mode)

;; These are only required at compile time to get the sources for the
;; language constants.  (The cc-fonts require and the font-lock
;; related constants could additionally be put inside an
;; (eval-after-load "font-lock" ...) but then some trickery is
;; necessary to get them compiled.)
(eval-when-compile
  (require 'cc-langs)
  (require 'cc-fonts))

(eval-and-compile
  ;; Make our mode known to the language constant system.  Use Java
  ;; mode as the fallback for the constants we don't change here.
  ;; This needs to be done also at compile time since the language
  ;; constants are evaluated then.
  (c-add-language 'zig-mode 'c-mode))

(c-lang-defconst c-symbol-start zig (concat "[" c-alpha "_@]"))

(c-lang-defconst c-primitive-type-kwds
  zig
  '(
    ;; Integer types
    "i2" "u2" "i3" "u3" "i4" "u4" "i5" "u5" "i6" "u6" "i7" "u7" "i8" "u8"
    "i16" "u16" "i29" "u29" "i32" "u32" "i64" "u64" "i128" "u128"
    "isize" "usize"

    ;; Floating types
    "f16" "f32" "f64" "f128"

    ;; C types
    "c_short" "c_ushort" "c_int" "c_uint" "c_long" "c_ulong"
    "c_longlong" "c_ulonglong" "c_longdouble" "c_void"

    ;; Comptime types
    "comptime_int" "comptime_float"

    ;; Other types
    "bool" "void" "noreturn" "type" "error" "anyerror" "promise"))

;; Function declarations begin with "function" in this language.
;; There's currently no special keyword list for that in CC Mode, but
;; treating it as a modifier works fairly well.
(c-lang-defconst c-modifier-kwds
  zig
  '(
    "const" "var" "extern" "packed" "export" "noalias" "inline"
    "comptime" "nakedcc" "stdcallcc" "threadlocal" "volatile" "align"
    "linksection" "fn"))

(c-lang-defconst c-protection-kwds zig '("pub"))

(c-lang-defconst c-class-decl-kwds zig '("struct" "enum" "union"))

(c-lang-defconst c-block-stmt-2-kwds zig '("for" "if" "switch" "while"))

(c-lang-defconst c-block-stmt-1-kwds zig '("else"))

(c-lang-defconst c-simple-stmt-kwds
  zig
  '("asm" "async" "await" "break" "cancel" "continue" "defer" "errdefer"
    "resume" "suspend" "test" "try" "unreachable" "use"))

(c-lang-defconst c-before-label-kwds zig '("break" "continue"))

(c-lang-defconst c-constant-kwds zig '("false" "null" "true" "undefined"))

(c-lang-defconst c-block-comment-starter zig nil)
(c-lang-defconst c-block-comment-ender zig nil)

;; TODO not fully done yet
(c-lang-defconst c-operators
  zig
  `(
    (prefix "-" "-%" "~" "!" "&")
    (postfix ".?" ".*")
    (left-assoc "+" "+%" "-" "-%"
		"*" "*%" "/" "%"
		"<<" ">>" "&" "|" "^"
		"<" ">" "<=" ">=" "==" "!="
		"++" "**" "||"
		"and" "or"
		"catch" "orelse")
    (right-assoc "=" "+=" "+%=" "-=" "-%="
		 "*=" "*%=" "/=" "%="
		 "<<=" ">>=" "&=" "|=" "^=")))
    

;;;###autoload
(defun zig-mode ()
  (interactive)
  (kill-all-local-variables)
  (c-initialize-cc-mode t)
  (setq major-mode 'zig-mode
	mode-name "Zig"
	abbrev-mode t)
  (c-init-language-vars zig-mode)
  (c-common-init 'zig-mode)
  (run-hooks 'c-mode-common-hook)
  (run-hooks 'zig-mode-hook)
  (c-update-modeline))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.zig\\'" . zig-mode))

(provide 'zig-mode)
