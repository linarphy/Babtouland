class StringParser
!!!242434.php!!!	addFilter(in type : , in callback : )
		// make sure the function is callable
		if (!is_callable ($callback)) {
			return false;
		}
		
		switch ($type) {
			case STRINGPARSER_FILTER_PRE:
				$this->_prefilters[] = $callback;
				break;
			case STRINGPARSER_FILTER_POST:
				$this->_postfilters[] = $callback;
				break;
			default:
				return false;
		}
		
		return true;
!!!242562.php!!!	clearFilters(in type :  = 0)
		switch ($type) {
			case 0:
				$this->_prefilters = array ();
				$this->_postfilters = array ();
				break;
			case STRINGPARSER_FILTER_PRE:
				$this->_prefilters = array ();
				break;
			case STRINGPARSER_FILTER_POST:
				$this->_postfilters = array ();
				break;
			default:
				return false;
		}
		return true;
!!!242690.php!!!	parse(in text : )
		if ($this->_parsing) {
			return false;
		}
		$this->_parsing = true;
		$this->_text = $this->_applyPrefilters ($text);
		$this->_output = null;
		$this->_length = strlen ($this->_text);
		$this->_cpos = 0;
		unset ($this->_stack);
		$this->_stack = array ();
		if (is_object ($this->_root)) {
			StringParser_Node::destroyNode ($this->_root);
		}
		unset ($this->_root);
		$this->_root = new StringParser_Node_Root ();
		$this->_stack[0] = $this->_root;
		
		$this->_parserInit ();
		
		$finished = false;
		
		while (!$finished) {
			switch ($this->_parserMode) {
				case STRINGPARSER_MODE_SEARCH:
					$res = $this->_searchLoop ();
					if (!$res) {
						$this->_parsing = false;
						return false;
					}
					break;
				case STRINGPARSER_MODE_LOOP:
					$res = $this->_loop ();
					if (!$res) {
						$this->_parsing = false;
						return false;
					}
					break;
				default:
					$this->_parsing = false;
					return false;
			}
			
			$res = $this->_closeRemainingBlocks ();
			if (!$res) {
				if ($this->strict) {
					$this->_parsing = false;
					return false;
				} else {
					$res = $this->_reparseAfterCurrentBlock ();
					if (!$res) {
						$this->_parsing = false;
						return false;
					}
					continue;
				}
			}
			$finished = true;
		}
		
		$res = $this->_modifyTree ();
		
		if (!$res) {
			$this->_parsing = false;
			return false;
		}
		
		$res = $this->_outputTree ();
		
		if (!$res) {
			$this->_parsing = false;
			return false;
		}
		
		if (is_null ($this->_output)) {
			$root = $this->_root;
			unset ($this->_root);
			$this->_root = null;
			while (count ($this->_stack)) {
				unset ($this->_stack[count($this->_stack)-1]);
			}
			$this->_stack = array ();
			$this->_parsing = false;
			return $root;
		}
		$StringParserNode=new StringParser_Node;
		$res = $StringParserNode->destroyNode ($this->_root);
		if (!$res) {
			$this->_parsing = false;
			return false;
		}
		unset ($this->_root);
		$this->_root = null;
		while (count ($this->_stack)) {
			unset ($this->_stack[count($this->_stack)-1]);
		}
		$this->_stack = array ();
		
		$this->_parsing = false;
		return $this->_output;
!!!242818.php!!!	_applyPrefilters(in text : )
		foreach ($this->_prefilters as $filter) {
			if (is_callable ($filter)) {
				$ntext = call_user_func ($filter, $text);
				if (is_string ($ntext)) {
					$text = $ntext;
				}
			}
		}
		return $text;
!!!242946.php!!!	_applyPostfilters(in text : )
		foreach ($this->_postfilters as $filter) {
			if (is_callable ($filter)) {
				$ntext = call_user_func ($filter, $text);
				if (is_string ($ntext)) {
					$text = $ntext;
				}
			}
		}
		return $text;
!!!243074.php!!!	_modifyTree()
		return true;
!!!243202.php!!!	_outputTree()
		// this could e.g. call _applyPostfilters
		return true;
!!!243330.php!!!	_reparseAfterCurrentBlock()
		// this should definitely not happen!
		if (($stack_count = count ($this->_stack)) < 2) {
			return false;
		}
		$topelem = $this->_stack[$stack_count-1];
		
		$node_parent = $topelem->_parent;
		// remove the child from the tree
		$res = $node_parent->removeChild ($topelem, false);
		if (!$res) {
			return false;
		}
		$res = $this->_popNode ();
		if (!$res) {
			return false;
		}
		
		// now try to get the position of the object
		if ($topelem->occurredAt < 0) {
			return false;
		}
		// HACK: could it be necessary to set a different status
		// if yes, how should this be achieved? Another member of
		// StringParser_Node?
		$this->_setStatus (0);
		$res = $this->_appendText ($this->_text{$topelem->occurredAt});
		if (!$res) {
			return false;
		}
		
		$this->_cpos = $topelem->occurredAt + 1;
		$this->_recentlyReparsed = true;
		
		return true;
!!!243458.php!!!	_closeRemainingBlocks()
		// everything closed
		if (count ($this->_stack) == 1) {
			return true;
		}
		// not everything closed
		if ($this->strict) {
			return false;
		}
		while (count ($this->_stack) > 1) {
			$res = $this->_popNode ();
			if (!$res) {
				return false;
			}
		}
		return true;
!!!243586.php!!!	_parserInit()
		$this->_setStatus (0);
!!!243714.php!!!	_setStatus(in status : )
		if ($status != 0) {
			return false;
		}
		$this->_charactersSearch = array ();
		$this->_charactersAllowed = array ();
		$this->_status = $status;
		return true;
!!!243842.php!!!	_handleStatus(in status : , in needle : )
		$this->_appendText ($needle);
		$this->_cpos += strlen ($needle);
		return true;
!!!243970.php!!!	_searchLoop()
		$i = 0;
		while (1) {
			// make sure this is false!
			$this->_recentlyReparsed = false;
			
			list ($needle, $offset) = $this->_strpos ($this->_charactersSearch, $this->_cpos);
			// parser ends here
			if ($needle === false) {
				// original status 0 => no problem
				if (!$this->_status) {
					break;
				}
				// not in original status? strict mode?
				if ($this->strict) {
					return false;
				}
				// break up parsing operation of current node
				$res = $this->_reparseAfterCurrentBlock ();
				if (!$res) {
					return false;
				}
				continue;
			}
			// get subtext
			$subtext = substr ($this->_text, $this->_cpos, $offset - $this->_cpos);
			$res = $this->_appendText ($subtext);
			if (!$res) {
				return false;
			}
			$this->_cpos = $offset;
			$res = $this->_handleStatus ($this->_status, $needle);
			if (!$res && $this->strict) {
				return false;
			}
			if (!$res) {
				$res = $this->_appendText ($this->_text{$this->_cpos});
				if (!$res) {
					return false;
				}
				$this->_cpos++;
				continue;
			}
			if ($this->_recentlyReparsed) {
				$this->_recentlyReparsed = false;
				continue;
			}
			$this->_cpos += strlen ($needle);
		}
		
		// get subtext
		if ($this->_cpos < strlen ($this->_text)) {
			$subtext = substr ($this->_text, $this->_cpos);
			$res = $this->_appendText ($subtext);
			if (!$res) {
				return false;
			}
		}
		
		return true;
!!!244098.php!!!	_loop()
		// HACK: This method ist not yet implemented correctly, the code below
		// DOES NOT WORK! Do not use!
		
		return false;
		/*
		while ($this->_cpos < $this->_length) {
			$needle = $this->_strDetect ($this->_charactersSearch, $this->_cpos);
			
			if ($needle === false) {
				// not found => see if character is allowed
				if (!in_array ($this->_text{$this->_cpos}, $this->_charactersAllowed)) {
					if ($strict) {
						return false;
					}
					// ignore
					continue;
				}
				// lot's of FIXMES
				$res = $this->_appendText ($this->_text{$this->_cpos});
				if (!$res) {
					return false;
				}
			}
			
			// get subtext
			$subtext = substr ($this->_text, $offset, $offset - $this->_cpos);
			$res = $this->_appendText ($subtext);
			if (!$res) {
				return false;
			}
			$this->_cpos = $subtext;
			$res = $this->_handleStatus ($this->_status, $needle);
			if (!$res && $strict) {
				return false;
			}
		}
		// original status 0 => no problem
		if (!$this->_status) {
			return true;
		}
		// not in original status? strict mode?
		if ($this->strict) {
			return false;
		}
		// break up parsing operation of current node
		$res = $this->_reparseAfterCurrentBlock ();
		if (!$res) {
			return false;
		}
		// this will not cause an infinite loop because
		// _reparseAfterCurrentBlock will increase _cpos by one!
		return $this->_loop ();
		*/
!!!244226.php!!!	_appendText(in text : )
		if (!strlen ($text)) {
			return true;
		}
		// default: call _appendToLastTextChild
		return $this->_appendToLastTextChild ($text);
!!!244354.php!!!	_appendToLastTextChild(in text : )
		$scount = count ($this->_stack);
		if ($scount == 0) {
			return false;
		}
		return $this->_stack[$scount-1]->appendToLastTextChild ($text);
!!!244482.php!!!	_strpos(in needles : , in offset : )
		$cur_needle = false;
		$cur_offset = -1;
		
		if ($offset < strlen ($this->_text)) {
			foreach ($needles as $needle) {
				$n_offset = strpos ($this->_text, $needle, $offset);
				if ($n_offset !== false && ($n_offset < $cur_offset || $cur_offset < 0)) {
					$cur_needle = $needle;
					$cur_offset = $n_offset;
				}
			}
		}
		
		return array ($cur_needle, $cur_offset, 'needle' => $cur_needle, 'offset' => $cur_offset);
!!!244610.php!!!	_strDetect(in needles : , in offset : )
		foreach ($needles as $needle) {
			$l = strlen ($needle);
			if (substr ($this->_text, $offset, $l) == $needle) {
				return $needle;
			}
		}
		return false;
!!!244738.php!!!	_pushNode(inout node : )
		$stack_count = count ($this->_stack);
		$max_node = $this->_stack[$stack_count-1];
		if (!$max_node->appendChild ($node)) {
			return false;
		}
		$this->_stack[$stack_count] = $node;
		return true;
!!!244866.php!!!	_popNode()
		$stack_count = count ($this->_stack);
		unset ($this->_stack[$stack_count-1]);
		return true;
!!!244994.php!!!	_topNode()
		$args = func_get_args ();
		if (!count ($args)) {
			return; // oops?
		}
		$method = array_shift ($args);
		$stack_count = count ($this->_stack);
		$method = array (&$this->_stack[$stack_count-1], $method);
		if (!is_callable ($method)) {
			return; // oops?
		}
		return call_user_func_array ($method, $args);
!!!245122.php!!!	_topNodeVar(in var : )
		$stack_count = count ($this->_stack);
		return $this->_stack[$stack_count-1]->$var;
