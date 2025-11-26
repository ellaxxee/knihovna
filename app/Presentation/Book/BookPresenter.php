<?php

declare(strict_types=1);

namespace App\Presentation\Book;

use Nette;
use Nette\Application\UI\Form;
use Nette\Database\Explorer;

final class BookPresenter extends Nette\Application\UI\Presenter
{
    private Explorer $db;

    public function __construct(Explorer $db)
    {
        $this->db = $db;
    }

    public function renderDefault(?int $id = null): void
    {
        $this->template->books = $this->db->table('books')->order('id DESC')->fetchAll();
        $this->template->editing = false;

        if ($id) {
            $book = $this->db->table('books')->get($id);
            if ($book) {
                $this['bookForm']->setDefaults($book->toArray());
                $this->template->editing = true;
            }
        }
    }

    protected function createComponentBookForm(): Form
    {
        $form = new Form;

        $form->addText('title', 'Name of the book:')
            ->setRequired('Add a book title.');

        $form->addText('author', 'Author:')
            ->setRequired('Add the author name.');

        $form->addText('isbn', 'ISBN:')
            ->setRequired('Add ISBN.');

        $form->addInteger('publication_year', 'Publication Year:')
            ->setHtmlAttribute('min', 0)
            ->setHtmlAttribute('max', date('Y'))
            ->setRequired('Add publication year.');

        $form->addText('genre', 'Genre::')
            ->setRequired('Add genre.');

        $form->addInteger('total_copies', "Total copies:")
            ->setRequired('Add total number of copies.')
            ->addRule($form::Min, 'The count has to be at least 1.', 1);

        $form->addInteger('available_copies', 'Avaliable copies:')
            ->setRequired('Add number of available copies.')
            ->addRule($form::Min, 'The count must be at least 0', 0);

        $form->addSubmit('send', 'Save');
        $form->onSuccess[] = [$this, 'bookFormSucceeded'];

        return $form;
    }

    public function bookFormSucceeded(Form $form, \stdClass $values): void
    {
        $id = $this->getParameter('id');

        $data = [
            'title' => $values->title,
            'author' => $values->author,
            'isbn' => $values->isbn,
            'publication_year' => $values->publication_year,
            'genre' => $values->genre,
            'total_copies' => $values->total_copies,
            'available_copies' => $values->available_copies,
            'added_at' => new \DateTime(),
        ];

        if ($id) {
            $this->db->table('books')->get($id)?->update($data);
            $this->flashMessage('The book has been updated.');
        } else {
            $this->db->table('books')->insert($data);
            $this->flashMessage('The book has been added.');
        }

        $this->redirect('default');
    }

    public function handleDelete(int $id): void
    {
        $this->db->table('books')->get($id)?->delete();
        $this->flashMessage('The book has been deleted.');
        $this->redirect('this');
    }
}