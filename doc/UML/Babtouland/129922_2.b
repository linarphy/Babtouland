class StringParser_BBCode_Node_Element
!!!148354.php!!!	duplicate() : object
		$newnode = new StringParser_BBCode_Node_Element ($this->occurredAt);
		$newnode->_name = $this->_name;
		$newnode->_flags = $this->_flags;
		$newnode->_attributes = $this->_attributes;
		$newnode->_hadCloseTag = $this->_hadCloseTag;
		$newnode->_paragraphHandled = $this->_paragraphHandled;
		$newnode->_codeInfo = $this->_codeInfo;
		return $newnode;
!!!148482.php!!!	name() : string
		return $this->_name;
!!!148610.php!!!	setName(in name : string)
		$this->_name = $name;
		return true;
!!!148738.php!!!	appendToName(in chars : string)
		$this->_name .= $chars;
		return true;
!!!148866.php!!!	appendToAttribute(in name : string, in chars : string)
		if (!isset ($this->_attributes[$name])) {
			$this->_attributes[$name] = $chars;
			return true;
		}
		$this->_attributes[$name] .= $chars;
		return true;
!!!148994.php!!!	setAttribute(in name : string, in value : string)
		$this->_attributes[$name] = $value;
		return true;
!!!149122.php!!!	setCodeInfo(in info : array)
		$this->_codeInfo = $info;
		$this->_flags = $info['flags'];
		return true;
!!!149250.php!!!	attribute(in name : string)
		if (!isset ($this->_attributes[$name])) {
			return null;
		}
		return $this->_attributes[$name];
!!!149378.php!!!	setHadCloseTag()
		$this->_hadCloseTag = true;
!!!149506.php!!!	setParagraphHandled()
		$this->_paragraphHandled = true;
!!!149634.php!!!	paragraphHandled() : bool
		return $this->_paragraphHandled;
!!!149762.php!!!	hadCloseTag() : bool
		return $this->_hadCloseTag;
!!!149890.php!!!	matchesCriterium(in criterium : string, in value : mixed) : bool
		if ($criterium == 'tagName') {
			return ($value == $this->_name);
		}
		if ($criterium == 'needsTextNodeModification') {
			return (($this->getFlag ('opentag.before.newline', 'integer', BBCODE_NEWLINE_PARSE) != BBCODE_NEWLINE_PARSE || $this->getFlag ('opentag.after.newline', 'integer', BBCODE_NEWLINE_PARSE) != BBCODE_NEWLINE_PARSE || ($this->_hadCloseTag && ($this->getFlag ('closetag.before.newline', 'integer', BBCODE_NEWLINE_PARSE) != BBCODE_NEWLINE_PARSE || $this->getFlag ('closetag.after.newline', 'integer', BBCODE_NEWLINE_PARSE) != BBCODE_NEWLINE_PARSE))) == (bool)$value);
		}
		if (substr ($criterium, 0, 5) == 'flag:') {
			$criterium = substr ($criterium, 5);
			return ($this->getFlag ($criterium) == $value);
		}
		if (substr ($criterium, 0, 6) == '!flag:') {
			$criterium = substr ($criterium, 6);
			return ($this->getFlag ($criterium) != $value);
		}
		if (substr ($criterium, 0, 6) == 'flag=:') {
			$criterium = substr ($criterium, 6);
			return ($this->getFlag ($criterium) === $value);
		}
		if (substr ($criterium, 0, 7) == '!flag=:') {
			$criterium = substr ($criterium, 7);
			return ($this->getFlag ($criterium) !== $value);
		}
		return parent::matchesCriterium ($criterium, $value);
!!!150018.php!!!	firstChildIfText() : mixed
		$ret = $this->firstChild ();
		if (is_null ($ret)) {
			return $ret;
		}
		if ($ret->_type != STRINGPARSER_NODE_TEXT) {
			// DON'T DO $ret = null WITHOUT unset BEFORE!
			// ELSE WE WILL ERASE THE NODE ITSELF! EVIL!
			unset ($ret);
			$ret = null;
		}
		return $ret;
!!!150146.php!!!	lastChildIfText() : mixed
		$ret = $this->lastChild ();
		if (is_null ($ret)) {
			return $ret;
		}
		if ($ret->_type != STRINGPARSER_NODE_TEXT || !$this->_hadCloseTag) {
			// DON'T DO $ret = null WITHOUT unset BEFORE!
			// ELSE WE WILL ERASE THE NODE ITSELF! EVIL!
			if ($ret->_type != STRINGPARSER_NODE_TEXT && !$ret->hadCloseTag ()) {
				$ret2 = $ret->_findPrevAdjentTextNodeHelper ();
				unset ($ret);
				$ret = $ret2;
				unset ($ret2);
			} else {
				unset ($ret);
				$ret = null;
			}
		}
		return $ret;
!!!150274.php!!!	findNextAdjentTextNode() : mixed
		$ret = null;
		if (is_null ($this->_parent)) {
			return $ret;
		}
		if (!$this->_hadCloseTag) {
			return $ret;
		}
		$ccount = count ($this->_parent->_children);
		$found = false;
		for ($i = 0; $i < $ccount; $i++) {
			if ($this->_parent->_children[$i]->equals ($this)) {
				$found = $i;
				break;
			}
		}
		if ($found === false) {
			return $ret;
		}
		if ($found < $ccount - 1) {
			if ($this->_parent->_children[$found+1]->_type == STRINGPARSER_NODE_TEXT) {
				return $this->_parent->_children[$found+1];
			}
			return $ret;
		}
		if ($this->_parent->_type == STRINGPARSER_BBCODE_NODE_ELEMENT && !$this->_parent->hadCloseTag ()) {
			$ret = $this->_parent->findNextAdjentTextNode ();
			return $ret;
		}
		return $ret;
!!!150402.php!!!	findPrevAdjentTextNode() : mixed
		$ret = null;
		if (is_null ($this->_parent)) {
			return $ret;
		}
		$ccount = count ($this->_parent->_children);
		$found = false;
		for ($i = 0; $i < $ccount; $i++) {
			if ($this->_parent->_children[$i]->equals ($this)) {
				$found = $i;
				break;
			}
		}
		if ($found === false) {
			return $ret;
		}
		if ($found > 0) {
			if ($this->_parent->_children[$found-1]->_type == STRINGPARSER_NODE_TEXT) {
				return $this->_parent->_children[$found-1];
			}
			if (!$this->_parent->_children[$found-1]->hadCloseTag ()) {
				$ret = $this->_parent->_children[$found-1]->_findPrevAdjentTextNodeHelper ();
			}
			return $ret;
		}
		return $ret;
!!!150530.php!!!	_findPrevAdjentTextNodeHelper()
		$lastnode = $this->lastChild ();
		if ($lastnode === null || $lastnode->_type == STRINGPARSER_NODE_TEXT) {
			return $lastnode;
		}
		if (!$lastnode->hadCloseTag ()) {
			$ret = $lastnode->_findPrevAdjentTextNodeHelper ();
		} else {
			$ret = null;
		}
		return $ret;
!!!150658.php!!!	getFlag(in flag : string, in type : string = 'mixed', in default : mixed = null) : mixed
		if (!isset ($this->_flags[$flag])) {
			return $default;
		}
		$return = $this->_flags[$flag];
		if ($type != 'mixed') {
			settype ($return, $type);
		}
		return $return;
!!!150786.php!!!	setFlag(in name : string, in value : mixed)
		$this->_flags[$name] = $value;
		return true;
!!!150914.php!!!	validate(in action : string = 'validate') : bool
		if ($action != 'validate' && $action != 'validate_again') {
			return false;
		}
		if ($this->_codeInfo['callback_type'] != 'simple_replace' && $this->_codeInfo['callback_type'] != 'simple_replace_single') {
			if (!is_callable ($this->_codeInfo['callback_func'])) {
				return false;
			}
			
			if (($this->_codeInfo['callback_type'] == 'usecontent' || $this->_codeInfo['callback_type'] == 'usecontent?' || $this->_codeInfo['callback_type'] == 'callback_replace?') && count ($this->_children) == 1 && $this->_children[0]->_type == STRINGPARSER_NODE_TEXT) {
				// we have to make sure the object gets passed on as a reference
				// if we do call_user_func(..., &$this) this will clash with PHP5
				$callArray = array ($action, $this->_attributes, $this->_children[0]->content, $this->_codeInfo['callback_params']);
				$callArray[] = $this;
				$res = call_user_func_array ($this->_codeInfo['callback_func'], $callArray);
				if ($res) {
					// ok, now, if we've got a usecontent type, set a flag that
					// this may not be broken up by paragraph handling!
					// but PLEASE do NOT change if already set to any other setting
					// than BBCODE_PARAGRAPH_ALLOW_BREAKUP because we could
					// override e.g. BBCODE_PARAGRAPH_BLOCK_ELEMENT!
					$val = $this->getFlag ('paragraph_type', 'integer', BBCODE_PARAGRAPH_ALLOW_BREAKUP);
					if ($val == BBCODE_PARAGRAPH_ALLOW_BREAKUP) {
						$this->_flags['paragraph_type'] = BBCODE_PARAGRAPH_ALLOW_INSIDE;
					}
				}
				return $res;
			}
			
			// we have to make sure the object gets passed on as a reference
			// if we do call_user_func(..., &$this) this will clash with PHP5
			$callArray = array ($action, $this->_attributes, null, $this->_codeInfo['callback_params']);
			$callArray[] = $this;
			return call_user_func_array ($this->_codeInfo['callback_func'], $callArray);
		}
		return (bool)(!count ($this->_attributes));
!!!151042.php!!!	getReplacement(in subcontent : string) : string
		if ($this->_codeInfo['callback_type'] == 'simple_replace' || $this->_codeInfo['callback_type'] == 'simple_replace_single') {
			if ($this->_codeInfo['callback_type'] == 'simple_replace_single') {
				if (strlen ($subcontent)) { // can't be!
					return false;
				}
				return $this->_codeInfo['callback_params']['start_tag'];
			}
			return $this->_codeInfo['callback_params']['start_tag'].$subcontent.$this->_codeInfo['callback_params']['end_tag'];
		}
		// else usecontent, usecontent? or callback_replace or callback_replace_single
		// => call function (the function is callable, determined in validate()!)
		
		// we have to make sure the object gets passed on as a reference
		// if we do call_user_func(..., &$this) this will clash with PHP5
		$callArray = array ('output', $this->_attributes, $subcontent, $this->_codeInfo['callback_params']);
		$callArray[] = $this;
		return call_user_func_array ($this->_codeInfo['callback_func'], $callArray);
!!!151170.php!!!	_dumpToString() : string
		$str = "bbcode \"".substr (preg_replace ('/\s+/', ' ', $this->_name), 0, 40)."\"";
		if (count ($this->_attributes)) {
			$attribs = array_keys ($this->_attributes);
			sort ($attribs);
			$str .= ' (';
			$i = 0;
			foreach ($attribs as $attrib) {
				if ($i != 0) {
					$str .= ', ';
				}
				$str .= $attrib.'="';
				$str .= substr (preg_replace ('/\s+/', ' ', $this->_attributes[$attrib]), 0, 10);
				$str .= '"';
				$i++;
			}
			$str .= ')';
		}
		return $str;
