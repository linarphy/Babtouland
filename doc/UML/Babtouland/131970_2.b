class Visiteur
!!!173826.php!!!	getPage() : Page

		return $this->page;
!!!173954.php!!!	setPage(in page : Page) : void

		$this->page=$page;
!!!174082.php!!!	afficherPage() : string

		return htmlspecialchars((string)$this->page->afficher());
!!!174210.php!!!	verifPermission() : bool

		return $this->getRole()->existPermission($this->getPage()->getApplication(), $this->getPage()->getAction());
!!!174338.php!!!	connexion(in motdepasse : string) : bool

		if ($this->getMotdepasse()->verif($motdepasse))
		{
			$utilisateurManager=$this->Manager();
			$date=date('Y-m-d H:i:s');
			$utilisateurManager->update(array(
				'date_connexion' => $date,
			), $this->getId());
			$this->setDate_connexion($date);
			$_SESSION['mdp']=$this->getMotdepasse()->getMdp_clair();
			$_SESSION['pseudo']=$this->getPseudo();
			$_SESSION['id']=$this->getId();
			return True;
		}
		else
		{
			return False;
		}
!!!174466.php!!!	deconnexion() : void

		if ($this->getMotdepasse()->verif($motdepasse))
		{
			$utilisateurManager=$this->Manager();
			$date=date('Y-m-d H:i:s');
			$utilisateurManager->update(array(
				'date_connexion' => $date,
			), $this->getId());
			$_SESSION=array();
		}
!!!174594.php!!!	inscription(in motdepasse : string, in nom_role : string) : void

		$VisiteurManager=$this->Manager();
		$VisiteurManager->add(array(				// Inscription dans la base de donnée
			'pseudo'           => $this->getPseudo(),
			'avatar'           => $this->getAvatar(),
			'date_inscription' => $this->getDate_inscription(),
			'date_connexion'   => $this->getDate_connexion(),
			'banni'            => (int)$this->getBanni(),
			'mail'             => $this->getMail(),
		));
		$this->setId($VisiteurManager->getIdBy(array(	// Récupération de l'id
			'pseudo'           => $this->getPseudo(),
			'avatar'           => $this->getAvatar(),
			'date_inscription' => $this->getDate_inscription(),
			'date_connexion'   => $this->getDate_connexion(),
			'banni'            => (int)$this->getBanni(),
			'mail'             => $this->getMail(),
		)));
		$this->setMotdepasse(new \user\Motdepasse(array(
			'id' => $this->getId(),
			'mdp_clair' => $motdepasse,
		)));
		$this->setRole(new \user\Role(array(
			'id' => $this->getId(),
			'nom_role' => $nom_role,
		)));
		$this->getRole()->recuperer_permissions();
		$RoleManager=$this->getRole()->Manager();
		$RoleManager->update(array(
			'nom_role' => $this->getRole()->getNom_role(),	// Inscription du role dans la table utilisateur
		), $this->getId());
		$MotdepasseManager=$this->getMotdepasse()->Manager();
		$this->getMotdepasse()->hash();
		$MotdepasseManager->update(array(					// Inscription du mot de passe
			'mot_de_passe' => $this->getMotdepasse()->getMot_de_passe(),
		), $this->getId());
		$BDDFactory=new \core\BDDFactory;
		$LiaisonConversationUtilisateur=new \chat\LiaisonConversationUtilisateur($BDDFactory->MysqlConnexion());
		global $config;
		$LiaisonConversationUtilisateur->addBy(array(array(			// On met l'utilisateur dans la conversation "général"
			'id_conversation' => $config['id_conversation_all'],
		)), array(
			'id_utilisateur' => $this->getId(),
		));
!!!174722.php!!!	mettre_a_jour() : void

		$Manager=$this->Manager();
		$Manager->update(array(
			'avatar' => $this->getAvatar(),
			'banni'  => (int)$this->getBanni(),
			'mail'   => $this->getMail(),
		), $this->getId());
!!!174850.php!!!	supprimer() : void

		$Manager=$this->Manager();
		$Manager->delete($this->getId());
!!!174978.php!!!	chargePage(in application : string, in action : string) : string

		global $config, $lang, $Visiteur;
		if($this->getRole()->existPermission($application, $action))	// Permission accordée
		{
			$this->setPage(new \user\Page(array(
				'application'   => $application,
				'action'        => $action,
			)));
			if (include($this->getPage()->getPath()))
			{
				return $this->getPage()->afficher();
			}
			else
			{
				throw new \Exception($lang['erreur_general_fichier_introuvable']);
			}
		}
		else
		{
			throw new \Exception($lang['erreur_general_autorisations_insuffisantes']);	// Pas l'autorisation
		}
