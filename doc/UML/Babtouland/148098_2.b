class Motdepasse
!!!263042.php!!!	getId()

		return $this->id;
!!!263170.php!!!	getMdp_clair()

		return $this->mdp_clair;
!!!263298.php!!!	getMot_de_passe()

		return $this->mot_de_passe;
!!!263426.php!!!	setId(in id : )

		$this->id=$id;
!!!263554.php!!!	setMdp_clair(in mdp_clair : )

		$this->mdp_clair=$mdp_clair;
!!!263682.php!!!	setMot_de_passe(in mot_de_passe : )

		$this->mot_de_passe=$mot_de_passe;
!!!263810.php!!!	afficherId()

		return htmlspecialchars((string)$this->id);
!!!263938.php!!!	afficherMdp_clair()

		return htmlspecialchars((string)$this->mdp_clair);
!!!264066.php!!!	afficherMdp_hash()

		return htmlspecialchars((string)$this->mdp_hash);
!!!264194.php!!!	hash()

		if ($this->getMdp_clair())
		{
			$mdp_hash=password_hash($this->getMdp_clair(), PASSWORD_DEFAULT);
			$this->setMot_de_passe($mdp_hash);
		}
!!!264322.php!!!	verif(in mot_de_passe : )

		if ($this->getMot_de_passe())
		{
			$password=$mot_de_passe;
			$hash=$this->getMot_de_passe();
			$options=array(
				'cost' => $this::HASH_COST,
			);
			if (password_verify($password, $hash))
			{
			    if (password_needs_rehash($hash, PASSWORD_DEFAULT, $options))
			    {
			        $this->setMot_de_passe(password_hash($password, PASSWORD_DEFAULT, $options));
			        $Mot_de_passeManager=$this->Manager();
			        $Mot_de_passeManager->update(array(
			        	'mot_de_passe' => $this->getMot_de_passe(),
			        ), $this->getId());
			    }
			    $this->setMdp_clair($mot_de_passe);
			    return True;
			}
			return False;
		}
		return False;
