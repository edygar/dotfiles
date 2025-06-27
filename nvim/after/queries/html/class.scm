;; extends
;; attributes with specific names and only assign value if more than 10 characters
(attribute
  (attribute_name) @_attribute_name
  (#match? @_attribute_name "^(src|style|href)$")
  (quoted_attribute_value
    (attribute_value) @_class_value) (#match? @_class_value "^.{50,}$")) ;; Assign @_class_value only if length > 10
