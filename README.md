org-trello
==========

Sync your org-mode files with your trello boards.

# under heavy development

Disclaimer:
- Not ready :D
- Possible api breakage and whatnot...

What works:
Only `C-c H` (not definitive binding) to push your org-mode modifications to trello asynchronously and bits by bits
(card, then checklist, then task).

# Contributions

Pull Requests welcome
cf. [What has been done and remains to be done](./TODO.org)

# why?

- org-mode is what I need.
- Trello is what my team need.
- org-trello may satisfy everybody.

# Release notes

## v0.0.1

- write only mode at the moment (org-mode pushes to trello, no reading yet)
- simple entity creation (card, checklist, item/task)                 - request asynchroneous
- complex entity creation (from card, including checklist, item/task) - request synchroneous (block emacs until done, need to be improved)
- entity deletion (card, checklist, item/task)
- Interactive command to ease the setup of the consumer-key and the access-token
- Interactive command to ease the setup of one org-mode file (which represents one trello board). I assume there exists
  a 'todo', 'doing', and 'done' list (named that way too)
- Control that the setup file (consumer-key and access-token) are rightly generated (to avoid later problem)
- Control that the properties on the current org-mode file are rightly setuped to access a trello board
- packaging for melpa

[More details on what has been done and remains to be done](./TODO.org)

# Setup

## Trello related

1) Retrieve your trello api key from https://trello.com/1/appKey/generate
Then add those entries inside the file `~/.trello/config.el`:

```emacs-lisp
;; -*- lisp -*-
(defvar consumer-key "your-consumer-key")
```

2) then connect to this url with your browser
https://trello.com/1/authorize?response_type=token&name=org-trello&scope=read,write&expiration=never&key=<consumer-key>
Add another entry inside the `~/.trello/config.el`

```emacs-lisp
(defvar access-token "your-access-token")
```

Then you're good to go.

## emacs related

orgtrello is a minor mode for org-mode to sync.

``` emacs-lisp
(require 'orgtrello)
```

## org-mode file

You need to make your org-mode buffer aware of trello.
At the moment, this routine is manual.

Add this to the top of your org-mode file

```org-mode
#+property: board-id      <BOARD-ID>
#+property: todo-list-id  <TODO-LIST-ID>
#+property: doing-list-id <DOING-LIST-ID>
#+property: done-list-id  <DONE-LIST-ID>
```

Example:

```org-mode
#+title: TODO orgtrello's dev progress
#+author: Antoine R. Dumont
#+property: board-id      50bcfd2f033110476000e768
#+property: todo-list-id  51d15c319c93af375200155f
#+property: doing-list-id 51d15c319c93af3752001500
#+property: done-list-id  51d15c319c93ag375200155f
```

# Use case

1. open an org-mode file
2. edit the identity of the desired board (must have been preset with the at least 3 columns - todo, doing, done - name
are not important but can be helpful to not lost oneself)
3. create a todo list following this line:

```org-mode
* card-identity
** checklist
*** task1
*** task2
*** task3
```

Actual bindings (not definitive, suggestions are welcome):
- *BINDING-SIMPLE-CREATION*  C-c H
- *BINDING-COMPLEX-CREATION* C-c j
- *BINDING-DELETION*         C-c k

Trello:
- Card:
  - Place yourself on the `card-identity` and hit the binding *BINDING-SIMPLE-CREATION*, this will create the card in the `TODO` column in your trello board
  - You can edit the title and hit *BINDING-SIMPLE-CREATION*, this will update the title in trello
  - Change the status from TODO to any intermediary status, then hit the binding, this will move the card to the list `DOING`.
  - Once done, move the status of the card from anything to DONE, hit the binding, this will move the card to the list `DONE`.
- Checklist:
  - Place yourself on the checklist `checklist`, hit the binding, this will add `checklist` as a checklist to your card `card-identity`
  - Rename your checklist and hit again the binding to update its label
- Task:
  - Place yourself on your task and hit *BINDING-SIMPLE-CREATION*, this will add the item to such checklist.
  - Change the name of the task and hit *BINDING-SIMPLE-CREATION*, this will update its label
  - Change the status of the task to `DONE` and hit the binding, this will check such item in trello.

# License

org-trello is free software under GPL v3. See COPYING file for details.
