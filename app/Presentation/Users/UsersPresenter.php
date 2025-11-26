<?php

declare(strict_types=1);

namespace App\Presentation\Users;

use Nette;
use Nette\Application\UI\Form;
use Nette\Database\Explorer;

final class UsersPresenter extends Nette\Application\UI\Presenter
{
    private Explorer $database;

    public function __construct(Explorer $database)
    {
        parent::__construct();
        $this->database = $database;
    }

    public function renderDefault(): void
    {
        $this->template->users = $this->database->table('users')->fetchAll();
    }

public function renderEdit(?int $id = null): void
{
    if ($id) {
        $user = $this->database->table('users')->get($id);
        if (!$user) {
            $this->error('No user found with the given ID.');
        }

        $defaults = $user->toArray();

        if (!in_array($defaults['role'], ['user', 'admin'])) {
            $defaults['role'] = 'user'; 
        }

        $this['userForm']->setDefaults($defaults);
    }
}
 protected function createComponentUserForm(): Form
{
    $form = new Form;

    $form->addText('username', 'Username:')
        ->setRequired('Add a username.');

    $form->addText('first_name', 'Name:')
        ->setRequired('Add a name.');

    $form->addText('last_name', 'Last name:')
        ->setRequired('Add a last name.');

    $form->addEmail('email', 'E-mail:')
        ->setRequired('Add an e-mail.');

    $form->addPassword('password', 'Password:')
        ->setRequired('Add a password.');

    $form->addSelect('role', 'Role:', [
    'user' => 'User',
    'admin' => 'Admin',
    'student' => 'Student',  
])->setPrompt('Select role');

    $form->addText('created_at', 'Created at:')
        ->setDefaultValue(date('Y-m-d H:i:s'))
        ->setDisabled();

    $form->addSubmit('send', 'Save');

    $form->onSuccess[] = [$this, 'userFormSucceeded'];

    return $form;
}
   public function userFormSucceeded(Form $form, \stdClass $values): void
{
    $id = $this->getParameter('id');

    if ($id) {
        $this->database->table('users')->get($id)->update([
            'username' => $values->username,
            'first_name' => $values->first_name,
            'last_name' => $values->last_name,
            'email' => $values->email,
            'password' => password_hash($values->password, PASSWORD_DEFAULT),
            'role' => $values->role,
        ]);
        $this->flashMessage('Uživatel byl upraven.', 'success');
    } else {
        $this->database->table('users')->insert([
            'username' => $values->username,
            'first_name' => $values->first_name,
            'last_name' => $values->last_name,
            'email' => $values->email,
            'password' => password_hash($values->password, PASSWORD_DEFAULT),
            'role' => $values->role,
            'created_at' => date('Y-m-d H:i:s'),
        ]);
        $this->flashMessage('New user has been created.', 'success');
    }

    $this->redirect('default');
}

    public function handleDelete(int $id): void
    {
        $this->database->table('users')->where('id', $id)->delete();
        $this->flashMessage('The user has been deleted.', 'info');
        $this->redirect('this');
    }
}