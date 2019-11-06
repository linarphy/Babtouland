class StringParser_BBCode_Node_Paragraph
!!!253058.php!!!	matchesCriterium(in criterium : , in value : )
		if ($criterium == 'empty') {
			if (!count ($this->_children)) {
				return true;
			}
			if (count ($this->_children) > 1) {
				return false;
			}
			if ($this->_children[0]->_type != STRINGPARSER_NODE_TEXT) {
				return false;
			}
			if (!strlen ($this->_children[0]->content)) {
				return true;
			}
			if (strlen ($this->_children[0]->content) > 2) {
				return false;
			}
			$f_begin = $this->_children[0]->getFlag ('newlinemode.begin', 'integer', BBCODE_NEWLINE_PARSE);
			$f_end = $this->_children[0]->getFlag ('newlinemode.end', 'integer', BBCODE_NEWLINE_PARSE);
			$content = $this->_children[0]->content;
			if ($f_begin != BBCODE_NEWLINE_PARSE && $content{0} == "\n") {
				$content = substr ($content, 1);
			}
			if ($f_end != BBCODE_NEWLINE_PARSE && $content{strlen($content)-1} == "\n") {
				$content = substr ($content, 0, -1);
			}
			if (!strlen ($content)) {
				return true;
			}
			return false;
		}
